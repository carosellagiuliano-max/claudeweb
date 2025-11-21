-- =====================================================
-- Migration 006: Booking Rules
-- Description: Booking configuration and constraints
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- NO SHOW POLICY ENUM
-- =====================================================
CREATE TYPE no_show_policy AS ENUM (
  'none',             -- No penalty
  'charge_deposit',   -- Charge deposit amount
  'charge_full'       -- Charge full appointment cost
);

-- =====================================================
-- BOOKING RULES
-- =====================================================
-- Per-salon booking configuration
CREATE TABLE booking_rules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE UNIQUE,

  -- Lead Time
  min_lead_time_minutes INTEGER NOT NULL DEFAULT 60 CHECK (min_lead_time_minutes >= 0),
  -- Minimum time between now and appointment (e.g., 60 = must book at least 1 hour in advance)

  -- Booking Horizon
  max_booking_horizon_days INTEGER NOT NULL DEFAULT 90 CHECK (max_booking_horizon_days > 0),
  -- Maximum days in advance you can book (e.g., 90 = can book up to 3 months ahead)

  -- Cancellation
  cancellation_cutoff_hours INTEGER NOT NULL DEFAULT 24 CHECK (cancellation_cutoff_hours >= 0),
  -- How many hours before appointment can customer cancel without penalty

  -- Slot Settings
  slot_granularity_minutes INTEGER NOT NULL DEFAULT 15 CHECK (slot_granularity_minutes > 0),
  -- Time increments for slots (e.g., 15 = slots every 15 minutes: 10:00, 10:15, 10:30...)

  default_visit_buffer_minutes INTEGER NOT NULL DEFAULT 0 CHECK (default_visit_buffer_minutes >= 0),
  -- Extra buffer between appointments for cleaning/prep

  -- Reservation Settings
  reservation_ttl_minutes INTEGER NOT NULL DEFAULT 15 CHECK (reservation_ttl_minutes > 0),
  -- How long a "reserved" slot is held before auto-expiring

  max_concurrent_reservations INTEGER NOT NULL DEFAULT 3 CHECK (max_concurrent_reservations > 0),
  -- Max number of active reserved appointments per customer

  -- Deposit Settings
  default_deposit_required BOOLEAN NOT NULL DEFAULT false,
  default_deposit_percent NUMERIC(5, 2) NOT NULL DEFAULT 0 CHECK (default_deposit_percent >= 0 AND default_deposit_percent <= 100),
  -- Default deposit as percentage of total (e.g., 20.00 = 20%)

  minimum_deposit_amount_cents INTEGER NOT NULL DEFAULT 0 CHECK (minimum_deposit_amount_cents >= 0),
  -- Minimum deposit in cents (e.g., 2000 = CHF 20.00)

  -- No Show Handling
  no_show_policy no_show_policy NOT NULL DEFAULT 'none',
  no_show_fee_cents INTEGER, -- Fixed fee for no-shows (if not using deposit/full amount)

  -- Multi-Service Settings
  allow_multi_service_booking BOOLEAN NOT NULL DEFAULT true,
  max_services_per_booking INTEGER NOT NULL DEFAULT 5 CHECK (max_services_per_booking > 0),

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index
CREATE INDEX idx_booking_rules_salon ON booking_rules(salon_id);

CREATE TRIGGER update_booking_rules_updated_at
  BEFORE UPDATE ON booking_rules
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VALIDATION FUNCTIONS
-- =====================================================

-- Check if booking time is within allowed lead time
CREATE OR REPLACE FUNCTION validate_lead_time(
  p_salon_id UUID,
  p_starts_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_min_lead_time_minutes INTEGER;
  v_earliest_booking TIMESTAMPTZ;
BEGIN
  -- Get min lead time
  SELECT min_lead_time_minutes INTO v_min_lead_time_minutes
  FROM booking_rules
  WHERE salon_id = p_salon_id;

  IF v_min_lead_time_minutes IS NULL THEN
    v_min_lead_time_minutes := 60; -- Default 1 hour
  END IF;

  v_earliest_booking := NOW() + (v_min_lead_time_minutes || ' minutes')::INTERVAL;

  RETURN p_starts_at >= v_earliest_booking;
END;
$$ LANGUAGE plpgsql STABLE;

-- Check if booking time is within allowed horizon
CREATE OR REPLACE FUNCTION validate_booking_horizon(
  p_salon_id UUID,
  p_starts_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_max_horizon_days INTEGER;
  v_latest_booking TIMESTAMPTZ;
BEGIN
  -- Get max horizon
  SELECT max_booking_horizon_days INTO v_max_horizon_days
  FROM booking_rules
  WHERE salon_id = p_salon_id;

  IF v_max_horizon_days IS NULL THEN
    v_max_horizon_days := 90; -- Default 90 days
  END IF;

  v_latest_booking := NOW() + (v_max_horizon_days || ' days')::INTERVAL;

  RETURN p_starts_at <= v_latest_booking;
END;
$$ LANGUAGE plpgsql STABLE;

-- Check if cancellation is within allowed window
CREATE OR REPLACE FUNCTION validate_cancellation_cutoff(
  p_salon_id UUID,
  p_appointment_starts_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_cutoff_hours INTEGER;
  v_cutoff_time TIMESTAMPTZ;
BEGIN
  -- Get cancellation cutoff
  SELECT cancellation_cutoff_hours INTO v_cutoff_hours
  FROM booking_rules
  WHERE salon_id = p_salon_id;

  IF v_cutoff_hours IS NULL THEN
    v_cutoff_hours := 24; -- Default 24 hours
  END IF;

  v_cutoff_time := p_appointment_starts_at - (v_cutoff_hours || ' hours')::INTERVAL;

  RETURN NOW() <= v_cutoff_time;
END;
$$ LANGUAGE plpgsql STABLE;

-- Check if customer has too many active reservations
CREATE OR REPLACE FUNCTION validate_reservation_limit(
  p_salon_id UUID,
  p_customer_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_max_reservations INTEGER;
  v_current_reservations INTEGER;
BEGIN
  -- Get max concurrent reservations
  SELECT max_concurrent_reservations INTO v_max_reservations
  FROM booking_rules
  WHERE salon_id = p_salon_id;

  IF v_max_reservations IS NULL THEN
    v_max_reservations := 3; -- Default 3
  END IF;

  -- Count current reservations
  SELECT COUNT(*) INTO v_current_reservations
  FROM appointments
  WHERE salon_id = p_salon_id
    AND customer_id = p_customer_id
    AND status = 'reserved'
    AND reserved_until > NOW();

  RETURN v_current_reservations < v_max_reservations;
END;
$$ LANGUAGE plpgsql STABLE;

-- Calculate deposit amount for appointment
CREATE OR REPLACE FUNCTION calculate_deposit_amount(
  p_salon_id UUID,
  p_total_amount_cents INTEGER
)
RETURNS INTEGER AS $$
DECLARE
  v_deposit_percent NUMERIC(5, 2);
  v_minimum_cents INTEGER;
  v_calculated_cents INTEGER;
BEGIN
  -- Get deposit settings
  SELECT default_deposit_percent, minimum_deposit_amount_cents
  INTO v_deposit_percent, v_minimum_cents
  FROM booking_rules
  WHERE salon_id = p_salon_id;

  IF v_deposit_percent IS NULL THEN
    v_deposit_percent := 20.00; -- Default 20%
  END IF;

  IF v_minimum_cents IS NULL THEN
    v_minimum_cents := 1000; -- Default CHF 10.00
  END IF;

  -- Calculate deposit
  v_calculated_cents := (p_total_amount_cents * v_deposit_percent / 100)::INTEGER;

  -- Return max of calculated or minimum
  RETURN GREATEST(v_calculated_cents, v_minimum_cents);
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE booking_rules IS 'Per-salon booking configuration including lead time, horizon, cancellation policy, deposits, and no-show handling';

COMMENT ON COLUMN booking_rules.min_lead_time_minutes IS 'Minimum minutes between NOW and appointment start. E.g., 60 = must book at least 1 hour in advance';
COMMENT ON COLUMN booking_rules.max_booking_horizon_days IS 'Maximum days in advance booking is allowed. E.g., 90 = can book up to 3 months ahead';
COMMENT ON COLUMN booking_rules.cancellation_cutoff_hours IS 'Hours before appointment when cancellation is no longer free. E.g., 24 = must cancel 24h before';
COMMENT ON COLUMN booking_rules.slot_granularity_minutes IS 'Time increment for available slots. E.g., 15 = slots at :00, :15, :30, :45';
COMMENT ON COLUMN booking_rules.reservation_ttl_minutes IS 'Minutes a reserved slot is held before auto-expiring. Typically 15 minutes';
COMMENT ON COLUMN booking_rules.max_concurrent_reservations IS 'Max number of active reserved appointments per customer to prevent abuse';
COMMENT ON COLUMN booking_rules.default_deposit_percent IS 'Default deposit as percentage of total. E.g., 20.00 = 20%. Can be overridden per service';
COMMENT ON COLUMN booking_rules.no_show_policy IS 'What to charge for no-shows: none, charge_deposit, or charge_full';

COMMENT ON FUNCTION validate_lead_time IS 'Check if appointment time satisfies minimum lead time rule';
COMMENT ON FUNCTION validate_booking_horizon IS 'Check if appointment time is within allowed booking horizon';
COMMENT ON FUNCTION validate_cancellation_cutoff IS 'Check if current time allows free cancellation';
COMMENT ON FUNCTION validate_reservation_limit IS 'Check if customer has not exceeded max concurrent reservations';
COMMENT ON FUNCTION calculate_deposit_amount IS 'Calculate deposit amount based on salon rules and total appointment cost';
