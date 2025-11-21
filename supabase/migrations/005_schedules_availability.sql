-- =====================================================
-- Migration 005: Schedules & Availability
-- Description: Opening hours, staff schedules, absences, blocked times
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- DAY OF WEEK ENUM
-- =====================================================
CREATE TYPE day_of_week AS ENUM (
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday'
);

-- =====================================================
-- OPENING HOURS
-- =====================================================
-- Regular weekly opening hours for salon
CREATE TABLE opening_hours (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,

  -- Day
  day_of_week day_of_week NOT NULL,

  -- Times (stored as minutes since midnight in local timezone)
  -- This avoids DST issues
  open_time_minutes INTEGER NOT NULL CHECK (open_time_minutes >= 0 AND open_time_minutes < 1440),
  close_time_minutes INTEGER NOT NULL CHECK (close_time_minutes >= 0 AND close_time_minutes <= 1440),

  -- Closed Day
  is_closed BOOLEAN NOT NULL DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(salon_id, day_of_week),
  CHECK (close_time_minutes > open_time_minutes OR is_closed = true)
);

-- Indexes
CREATE INDEX idx_opening_hours_salon ON opening_hours(salon_id);

CREATE TRIGGER update_opening_hours_updated_at
  BEFORE UPDATE ON opening_hours
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STAFF WORKING HOURS
-- =====================================================
-- Regular weekly working hours per staff member
CREATE TABLE staff_working_hours (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  staff_id UUID NOT NULL REFERENCES staff(id) ON DELETE CASCADE,

  -- Day
  day_of_week day_of_week NOT NULL,

  -- Times (minutes since midnight)
  start_time_minutes INTEGER NOT NULL CHECK (start_time_minutes >= 0 AND start_time_minutes < 1440),
  end_time_minutes INTEGER NOT NULL CHECK (end_time_minutes >= 0 AND end_time_minutes <= 1440),

  -- Off Day
  is_day_off BOOLEAN NOT NULL DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(staff_id, day_of_week),
  CHECK (end_time_minutes > start_time_minutes OR is_day_off = true)
);

-- Indexes
CREATE INDEX idx_staff_working_hours_staff ON staff_working_hours(staff_id);

CREATE TRIGGER update_staff_working_hours_updated_at
  BEFORE UPDATE ON staff_working_hours
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STAFF ABSENCES
-- =====================================================
-- One-time absences (vacation, sick leave, etc.)
CREATE TABLE staff_absences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  staff_id UUID NOT NULL REFERENCES staff(id) ON DELETE CASCADE,

  -- Date Range
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,

  -- Reason
  reason TEXT, -- e.g., "Vacation", "Sick", "Training"
  notes TEXT, -- Internal notes

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CHECK (end_date >= start_date)
);

-- Indexes
CREATE INDEX idx_staff_absences_staff ON staff_absences(staff_id);
CREATE INDEX idx_staff_absences_dates ON staff_absences(staff_id, start_date, end_date);

CREATE TRIGGER update_staff_absences_updated_at
  BEFORE UPDATE ON staff_absences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- BLOCKED TIMES
-- =====================================================
-- One-time blocks (meetings, breaks, salon-wide closures)
CREATE TYPE blocked_time_type AS ENUM (
  'staff_break',      -- Staff break (lunch, etc.)
  'staff_meeting',    -- Staff meeting
  'salon_closed',     -- Entire salon closed
  'maintenance',      -- Maintenance/cleaning
  'other'            -- Other reason
);

CREATE TABLE blocked_times (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  staff_id UUID REFERENCES staff(id) ON DELETE CASCADE, -- NULL means salon-wide

  -- Time Range
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,

  -- Type & Reason
  block_type blocked_time_type NOT NULL,
  reason TEXT,
  notes TEXT,

  -- Recurrence (for future use)
  is_recurring BOOLEAN NOT NULL DEFAULT false,
  recurrence_rule TEXT, -- iCal RRULE format

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CHECK (ends_at > starts_at)
);

-- Indexes
CREATE INDEX idx_blocked_times_salon ON blocked_times(salon_id);
CREATE INDEX idx_blocked_times_staff ON blocked_times(staff_id);
CREATE INDEX idx_blocked_times_date ON blocked_times(salon_id, starts_at, ends_at);

CREATE TRIGGER update_blocked_times_updated_at
  BEFORE UPDATE ON blocked_times
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Convert minutes since midnight to time
CREATE OR REPLACE FUNCTION minutes_to_time(minutes INTEGER)
RETURNS TIME AS $$
BEGIN
  RETURN (minutes || ' minutes')::INTERVAL::TIME;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Convert time to minutes since midnight
CREATE OR REPLACE FUNCTION time_to_minutes(t TIME)
RETURNS INTEGER AS $$
BEGIN
  RETURN EXTRACT(HOUR FROM t)::INTEGER * 60 + EXTRACT(MINUTE FROM t)::INTEGER;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Get opening hours for a specific date
CREATE OR REPLACE FUNCTION get_opening_hours_for_date(
  p_salon_id UUID,
  p_date DATE
)
RETURNS TABLE (
  open_minutes INTEGER,
  close_minutes INTEGER,
  is_closed BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    oh.open_time_minutes,
    oh.close_time_minutes,
    oh.is_closed
  FROM opening_hours oh
  WHERE oh.salon_id = p_salon_id
    AND oh.day_of_week = LOWER(TO_CHAR(p_date, 'Day'))::day_of_week;
END;
$$ LANGUAGE plpgsql STABLE;

-- Check if staff is available at a given time
CREATE OR REPLACE FUNCTION is_staff_available(
  p_staff_id UUID,
  p_starts_at TIMESTAMPTZ,
  p_ends_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_absence_count INTEGER;
  v_blocked_count INTEGER;
  v_appointment_count INTEGER;
BEGIN
  -- Check absences
  SELECT COUNT(*) INTO v_absence_count
  FROM staff_absences
  WHERE staff_id = p_staff_id
    AND start_date <= p_starts_at::DATE
    AND end_date >= p_starts_at::DATE;

  IF v_absence_count > 0 THEN
    RETURN FALSE;
  END IF;

  -- Check blocked times
  SELECT COUNT(*) INTO v_blocked_count
  FROM blocked_times
  WHERE (staff_id = p_staff_id OR staff_id IS NULL) -- Staff-specific or salon-wide
    AND starts_at < p_ends_at
    AND ends_at > p_starts_at;

  IF v_blocked_count > 0 THEN
    RETURN FALSE;
  END IF;

  -- Check existing appointments
  SELECT COUNT(*) INTO v_appointment_count
  FROM appointments
  WHERE staff_id = p_staff_id
    AND status IN ('reserved', 'confirmed', 'requested')
    AND starts_at < p_ends_at
    AND ends_at > p_starts_at;

  IF v_appointment_count > 0 THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE opening_hours IS 'Regular weekly opening hours per salon. Times stored as minutes since midnight to avoid DST issues.';
COMMENT ON TABLE staff_working_hours IS 'Regular weekly working hours per staff member.';
COMMENT ON TABLE staff_absences IS 'One-time staff absences (vacation, sick leave, etc.)';
COMMENT ON TABLE blocked_times IS 'One-time blocks for staff or entire salon (breaks, meetings, closures)';

COMMENT ON COLUMN opening_hours.open_time_minutes IS 'Opening time as minutes since midnight (0-1439). Avoids DST issues.';
COMMENT ON COLUMN opening_hours.close_time_minutes IS 'Closing time as minutes since midnight. Can be 1440 for midnight.';
COMMENT ON COLUMN blocked_times.staff_id IS 'NULL means salon-wide block, otherwise staff-specific';

COMMENT ON FUNCTION is_staff_available IS 'Checks if staff is available considering absences, blocked times, and existing appointments';
COMMENT ON FUNCTION minutes_to_time IS 'Convert minutes since midnight to TIME type';
COMMENT ON FUNCTION time_to_minutes IS 'Convert TIME type to minutes since midnight';
