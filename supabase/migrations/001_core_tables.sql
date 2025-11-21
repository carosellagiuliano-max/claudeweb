-- =====================================================
-- Migration 001: Core Tables
-- Description: Salons, Profiles, Roles, User Roles
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- SALONS
-- =====================================================
CREATE TABLE salons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,

  -- Address
  street TEXT NOT NULL,
  street_number TEXT,
  postal_code TEXT NOT NULL,
  city TEXT NOT NULL,
  country TEXT NOT NULL DEFAULT 'CH',

  -- Contact
  phone TEXT,
  email TEXT,
  website TEXT,

  -- Social
  instagram_handle TEXT,
  facebook_url TEXT,

  -- Settings
  timezone TEXT NOT NULL DEFAULT 'Europe/Zurich',
  currency TEXT NOT NULL DEFAULT 'CHF',
  locale TEXT NOT NULL DEFAULT 'de-CH',

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for active salons
CREATE INDEX idx_salons_active ON salons(is_active) WHERE is_active = true;

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_salons_updated_at
  BEFORE UPDATE ON salons
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- PROFILES
-- =====================================================
-- Extends auth.users with additional profile data
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Personal Info
  email TEXT NOT NULL,
  first_name TEXT,
  last_name TEXT,
  phone TEXT,
  birth_date DATE,

  -- Avatar
  avatar_url TEXT,

  -- Preferences
  preferred_language TEXT DEFAULT 'de',

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for lookups
CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_active ON profiles(is_active) WHERE is_active = true;

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ROLES
-- =====================================================
CREATE TYPE role_name AS ENUM (
  'kunde',        -- Customer (customer portal access)
  'mitarbeiter',  -- Staff (view calendar, limited admin)
  'manager',      -- Manager (full salon operations)
  'admin',        -- Admin (full system access)
  'hq'            -- HQ (multi-salon overview)
);

CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name role_name NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Insert default roles
INSERT INTO roles (name, display_name, description) VALUES
  ('kunde', 'Kunde', 'Customer with access to customer portal'),
  ('mitarbeiter', 'Mitarbeiter', 'Staff member with calendar and basic admin access'),
  ('manager', 'Manager', 'Manager with full salon operations access'),
  ('admin', 'Administrator', 'Administrator with full system access'),
  ('hq', 'Headquarters', 'HQ role with multi-salon access');

-- =====================================================
-- USER ROLES
-- =====================================================
-- Maps users to roles within salon scope
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  salon_id UUID REFERENCES salons(id) ON DELETE CASCADE,
  role_name role_name NOT NULL,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(profile_id, salon_id, role_name)
);

-- Indexes for performance
CREATE INDEX idx_user_roles_profile ON user_roles(profile_id);
CREATE INDEX idx_user_roles_salon ON user_roles(salon_id);
CREATE INDEX idx_user_roles_lookup ON user_roles(profile_id, salon_id, role_name);

-- Check: HQ role should have NULL salon_id
CREATE OR REPLACE FUNCTION check_hq_role_salon()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.role_name = 'hq' AND NEW.salon_id IS NOT NULL THEN
    RAISE EXCEPTION 'HQ role must have NULL salon_id';
  END IF;

  IF NEW.role_name != 'hq' AND NEW.salon_id IS NULL THEN
    RAISE EXCEPTION 'Non-HQ roles must have a salon_id';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_hq_role_salon
  BEFORE INSERT OR UPDATE ON user_roles
  FOR EACH ROW
  EXECUTE FUNCTION check_hq_role_salon();

CREATE TRIGGER update_user_roles_updated_at
  BEFORE UPDATE ON user_roles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE salons IS 'Physical salon locations';
COMMENT ON TABLE profiles IS 'Extended user profile data linked to auth.users';
COMMENT ON TABLE roles IS 'System roles for RBAC';
COMMENT ON TABLE user_roles IS 'Maps users to roles within salon scope. HQ role has NULL salon_id.';

COMMENT ON COLUMN salons.timezone IS 'IANA timezone for appointment scheduling (e.g., Europe/Zurich)';
COMMENT ON COLUMN salons.currency IS 'ISO 4217 currency code (e.g., CHF)';
COMMENT ON COLUMN user_roles.salon_id IS 'NULL for HQ role, required for all other roles';
