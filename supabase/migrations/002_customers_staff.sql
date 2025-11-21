-- =====================================================
-- Migration 002: Customers & Staff
-- Description: Customer and Staff tables with skills
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- CUSTOMERS
-- =====================================================
CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Customer Preferences
  preferred_staff_id UUID, -- Self-referencing, added after staff table
  notes TEXT, -- Internal notes visible only to staff

  -- Marketing Preferences (GDPR)
  accepts_marketing_email BOOLEAN NOT NULL DEFAULT false,
  accepts_marketing_sms BOOLEAN NOT NULL DEFAULT false,

  -- Loyalty
  loyalty_tier TEXT DEFAULT 'standard', -- standard, silver, gold, platinum

  -- Stats (cached for performance)
  total_visits INTEGER NOT NULL DEFAULT 0,
  total_spend_cents INTEGER NOT NULL DEFAULT 0, -- In cents to avoid float issues

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  anonymized_at TIMESTAMPTZ, -- For GDPR deletion tracking

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(salon_id, profile_id)
);

-- Indexes
CREATE INDEX idx_customers_salon ON customers(salon_id);
CREATE INDEX idx_customers_profile ON customers(profile_id);
CREATE INDEX idx_customers_salon_active ON customers(salon_id, is_active) WHERE is_active = true;

CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STAFF
-- =====================================================
CREATE TABLE staff (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Staff Details
  display_name TEXT NOT NULL, -- Public-facing name
  bio TEXT,
  photo_url TEXT,

  -- Employment
  position TEXT, -- e.g., "Senior Stylist", "Colorist"
  hire_date DATE,

  -- Settings
  color TEXT DEFAULT '#3B82F6', -- Calendar color in hex
  sort_order INTEGER NOT NULL DEFAULT 0, -- For display ordering

  -- Bookability
  is_bookable_online BOOLEAN NOT NULL DEFAULT true,

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(salon_id, profile_id)
);

-- Indexes
CREATE INDEX idx_staff_salon ON staff(salon_id);
CREATE INDEX idx_staff_profile ON staff(profile_id);
CREATE INDEX idx_staff_salon_active ON staff(salon_id, is_active) WHERE is_active = true;
CREATE INDEX idx_staff_bookable ON staff(salon_id, is_bookable_online) WHERE is_bookable_online = true;

CREATE TRIGGER update_staff_updated_at
  BEFORE UPDATE ON staff
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STAFF SERVICE SKILLS
-- =====================================================
-- Junction table: which staff can perform which services
-- (services table will be created in next migration)
CREATE TABLE staff_service_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  staff_id UUID NOT NULL REFERENCES staff(id) ON DELETE CASCADE,
  service_id UUID NOT NULL, -- FK added in next migration

  -- Skill level (optional for future use)
  proficiency_level TEXT DEFAULT 'standard', -- standard, advanced, expert

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(staff_id, service_id)
);

-- Indexes
CREATE INDEX idx_staff_skills_staff ON staff_service_skills(staff_id);
CREATE INDEX idx_staff_skills_service ON staff_service_skills(service_id);

-- =====================================================
-- Add preferred_staff_id FK to customers
-- =====================================================
ALTER TABLE customers
  ADD CONSTRAINT fk_customers_preferred_staff
  FOREIGN KEY (preferred_staff_id)
  REFERENCES staff(id)
  ON DELETE SET NULL;

CREATE INDEX idx_customers_preferred_staff ON customers(preferred_staff_id);

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE customers IS 'Customers of a salon. Linked to profiles for auth.';
COMMENT ON TABLE staff IS 'Staff members of a salon. Also linked to profiles.';
COMMENT ON TABLE staff_service_skills IS 'Junction table mapping staff to services they can perform.';

COMMENT ON COLUMN customers.total_spend_cents IS 'Cached total lifetime spend in cents (CHF). Updated via triggers on orders.';
COMMENT ON COLUMN customers.anonymized_at IS 'Timestamp of GDPR deletion/anonymization. NULL means not anonymized.';
COMMENT ON COLUMN staff.is_bookable_online IS 'Whether this staff member can be booked online. Set to false to hide from booking UI.';
COMMENT ON COLUMN staff.color IS 'Hex color for calendar display (e.g., #3B82F6).';
