-- =====================================================
-- Migration 004: Appointments
-- Description: Appointment booking with race condition prevention
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- APPOINTMENT STATUS ENUM
-- =====================================================
CREATE TYPE appointment_status AS ENUM (
  'reserved',   -- Temporarily held (15min TTL)
  'requested',  -- Requested by customer (requires confirmation)
  'confirmed',  -- Confirmed and paid (if required)
  'completed',  -- Service completed
  'cancelled',  -- Cancelled by customer or staff
  'no_show'     -- Customer did not show up
);

-- =====================================================
-- APPOINTMENTS
-- =====================================================
CREATE TABLE appointments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  staff_id UUID NOT NULL REFERENCES staff(id) ON DELETE RESTRICT,

  -- Timing
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,

  -- Status
  status appointment_status NOT NULL DEFAULT 'reserved',
  reserved_until TIMESTAMPTZ, -- For reserved status: auto-cancel after this time

  -- Payment & Deposit
  deposit_required BOOLEAN NOT NULL DEFAULT false,
  deposit_paid BOOLEAN NOT NULL DEFAULT false,
  deposit_amount_cents INTEGER,

  total_price_cents INTEGER, -- Cached total from appointment_services

  -- Notes
  customer_notes TEXT, -- Notes from customer
  staff_notes TEXT, -- Internal notes from staff

  -- Cancellation
  cancelled_at TIMESTAMPTZ,
  cancelled_by UUID REFERENCES profiles(id),
  cancellation_reason TEXT,

  -- No Show
  no_show_marked_at TIMESTAMPTZ,
  no_show_fee_charged BOOLEAN DEFAULT false,

  -- Reminders
  reminder_sent_at TIMESTAMPTZ,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CHECK (ends_at > starts_at),
  CHECK (status != 'reserved' OR reserved_until IS NOT NULL)
);

-- =====================================================
-- CRITICAL INDEX: Prevent Double Bookings
-- =====================================================
-- Unique constraint: one staff can't have overlapping appointments
-- This prevents race conditions at DB level
CREATE UNIQUE INDEX idx_appointments_no_double_booking
  ON appointments(salon_id, staff_id, starts_at)
  WHERE status IN ('reserved', 'confirmed', 'requested');

-- Other indexes
CREATE INDEX idx_appointments_salon ON appointments(salon_id);
CREATE INDEX idx_appointments_customer ON appointments(customer_id);
CREATE INDEX idx_appointments_staff ON appointments(staff_id);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_date ON appointments(salon_id, starts_at);
CREATE INDEX idx_appointments_staff_date ON appointments(staff_id, starts_at);

-- Index for expired reservations cleanup
CREATE INDEX idx_appointments_expired_reservations
  ON appointments(status, reserved_until)
  WHERE status = 'reserved' AND reserved_until < NOW();

CREATE TRIGGER update_appointments_updated_at
  BEFORE UPDATE ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- APPOINTMENT SERVICES
-- =====================================================
-- Junction table: which services in this appointment
-- Allows multi-service appointments
CREATE TABLE appointment_services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  appointment_id UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  service_id UUID NOT NULL REFERENCES services(id) ON DELETE RESTRICT,

  -- Snapshot at booking time (for price history)
  snapshot_service_name TEXT NOT NULL,
  snapshot_price_cents INTEGER NOT NULL,
  snapshot_tax_rate_percent NUMERIC(5, 2) NOT NULL,
  snapshot_duration_minutes INTEGER NOT NULL,

  -- Order for multi-service appointments
  sort_order INTEGER NOT NULL DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_appointment_services_appointment ON appointment_services(appointment_id);
CREATE INDEX idx_appointment_services_service ON appointment_services(service_id);

-- =====================================================
-- FUNCTION: Calculate Appointment Total
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_appointment_total(p_appointment_id UUID)
RETURNS INTEGER AS $$
DECLARE
  v_total_cents INTEGER;
BEGIN
  SELECT COALESCE(SUM(snapshot_price_cents), 0)
  INTO v_total_cents
  FROM appointment_services
  WHERE appointment_id = p_appointment_id;

  RETURN v_total_cents;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================
-- TRIGGER: Update Total Price on Service Changes
-- =====================================================
CREATE OR REPLACE FUNCTION update_appointment_total()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE appointments
  SET
    total_price_cents = calculate_appointment_total(COALESCE(NEW.appointment_id, OLD.appointment_id)),
    updated_at = NOW()
  WHERE id = COALESCE(NEW.appointment_id, OLD.appointment_id);

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_appointment_total_insert
  AFTER INSERT ON appointment_services
  FOR EACH ROW
  EXECUTE FUNCTION update_appointment_total();

CREATE TRIGGER trigger_update_appointment_total_delete
  AFTER DELETE ON appointment_services
  FOR EACH ROW
  EXECUTE FUNCTION update_appointment_total();

-- =====================================================
-- FUNCTION: Clean Expired Reservations
-- =====================================================
-- Called by cron job to clean up expired reserved appointments
CREATE OR REPLACE FUNCTION clean_expired_reservations()
RETURNS INTEGER AS $$
DECLARE
  v_deleted_count INTEGER;
BEGIN
  WITH deleted AS (
    DELETE FROM appointments
    WHERE status = 'reserved'
      AND reserved_until < NOW()
    RETURNING id
  )
  SELECT COUNT(*) INTO v_deleted_count FROM deleted;

  RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCTION: Reserve Slot with Lock
-- =====================================================
-- Atomically check and reserve a slot
-- Returns TRUE if successful, FALSE if slot unavailable
CREATE OR REPLACE FUNCTION reserve_slot_with_lock(
  p_salon_id UUID,
  p_staff_id UUID,
  p_starts_at TIMESTAMPTZ,
  p_ends_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_conflict_count INTEGER;
BEGIN
  -- Advisory lock to prevent concurrent reservations
  PERFORM pg_advisory_xact_lock(
    hashtext(p_salon_id::TEXT || p_staff_id::TEXT || p_starts_at::TEXT)
  );

  -- Check for conflicts
  SELECT COUNT(*) INTO v_conflict_count
  FROM appointments
  WHERE salon_id = p_salon_id
    AND staff_id = p_staff_id
    AND status IN ('reserved', 'confirmed', 'requested')
    AND (
      -- Overlap detection
      (starts_at < p_ends_at AND ends_at > p_starts_at)
    );

  IF v_conflict_count > 0 THEN
    RETURN FALSE; -- Slot not available
  ELSE
    RETURN TRUE; -- Slot available
  END IF;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE appointments IS 'Appointments with double-booking prevention via unique index';
COMMENT ON TABLE appointment_services IS 'Services in appointment with snapshot pricing';

COMMENT ON INDEX idx_appointments_no_double_booking IS 'CRITICAL: Prevents double bookings by ensuring unique (salon, staff, starts_at) for active appointments';

COMMENT ON COLUMN appointments.status IS 'reserved: temp hold (15min), requested: needs confirmation, confirmed: paid if required, completed: done, cancelled: cancelled, no_show: missed';
COMMENT ON COLUMN appointments.reserved_until IS 'For reserved status: auto-expire after this time. Cleaned by cron job.';
COMMENT ON COLUMN appointments.total_price_cents IS 'Cached sum of appointment_services prices. Auto-updated by trigger.';
COMMENT ON COLUMN appointment_services.snapshot_price_cents IS 'Price at booking time for historical accuracy';

COMMENT ON FUNCTION reserve_slot_with_lock IS 'Atomically check and reserve slot with advisory lock to prevent race conditions';
COMMENT ON FUNCTION clean_expired_reservations IS 'Cleanup function called by cron to remove expired reservations';
