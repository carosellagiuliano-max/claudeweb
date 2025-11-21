-- =====================================================
-- Migration 008: Auth Triggers
-- Description: Auto-create profiles and handle auth lifecycle
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- TRIGGER: Auto-create profile on user registration
-- =====================================================

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Create profile for new user
  INSERT INTO public.profiles (id, email, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    NOW(),
    NOW()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users insert
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- =====================================================
-- TRIGGER: Update profile email when auth email changes
-- =====================================================

CREATE OR REPLACE FUNCTION handle_user_email_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email IS DISTINCT FROM OLD.email THEN
    UPDATE public.profiles
    SET
      email = NEW.email,
      updated_at = NOW()
    WHERE id = NEW.id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users update
CREATE TRIGGER on_auth_user_email_changed
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  WHEN (OLD.email IS DISTINCT FROM NEW.email)
  EXECUTE FUNCTION handle_user_email_change();

-- =====================================================
-- FUNCTION: Assign Customer Role
-- =====================================================
-- Call this after creating a customer record to give them kunde role
CREATE OR REPLACE FUNCTION assign_customer_role(
  p_profile_id UUID,
  p_salon_id UUID
)
RETURNS VOID AS $$
BEGIN
  -- Check if customer record exists
  IF NOT EXISTS (
    SELECT 1 FROM customers
    WHERE profile_id = p_profile_id
      AND salon_id = p_salon_id
  ) THEN
    RAISE EXCEPTION 'Customer record not found for profile % in salon %', p_profile_id, p_salon_id;
  END IF;

  -- Assign kunde role (idempotent)
  INSERT INTO user_roles (profile_id, salon_id, role_name)
  VALUES (p_profile_id, p_salon_id, 'kunde')
  ON CONFLICT (profile_id, salon_id, role_name) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- FUNCTION: Assign Staff Role
-- =====================================================
-- Call this after creating a staff record
CREATE OR REPLACE FUNCTION assign_staff_role(
  p_profile_id UUID,
  p_salon_id UUID,
  p_role_name role_name DEFAULT 'mitarbeiter'
)
RETURNS VOID AS $$
BEGIN
  -- Check if staff record exists
  IF NOT EXISTS (
    SELECT 1 FROM staff
    WHERE profile_id = p_profile_id
      AND salon_id = p_salon_id
  ) THEN
    RAISE EXCEPTION 'Staff record not found for profile % in salon %', p_profile_id, p_salon_id;
  END IF;

  -- Validate role
  IF p_role_name NOT IN ('mitarbeiter', 'manager', 'admin') THEN
    RAISE EXCEPTION 'Invalid staff role: %. Must be mitarbeiter, manager, or admin', p_role_name;
  END IF;

  -- Assign role (idempotent)
  INSERT INTO user_roles (profile_id, salon_id, role_name)
  VALUES (p_profile_id, p_salon_id, p_role_name)
  ON CONFLICT (profile_id, salon_id, role_name) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- TRIGGER: Auto-assign kunde role when customer created
-- =====================================================

CREATE OR REPLACE FUNCTION auto_assign_customer_role()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM assign_customer_role(NEW.profile_id, NEW.salon_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_customer_created
  AFTER INSERT ON customers
  FOR EACH ROW
  EXECUTE FUNCTION auto_assign_customer_role();

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON FUNCTION handle_new_user IS 'Auto-creates profile when new user registers via Supabase Auth';
COMMENT ON FUNCTION handle_user_email_change IS 'Syncs email changes from auth.users to profiles table';
COMMENT ON FUNCTION assign_customer_role IS 'Assigns kunde role to a profile for a specific salon';
COMMENT ON FUNCTION assign_staff_role IS 'Assigns staff role (mitarbeiter/manager/admin) to a profile for a specific salon';
COMMENT ON FUNCTION auto_assign_customer_role IS 'Auto-trigger to assign kunde role when customer record is created';

COMMENT ON TRIGGER on_auth_user_created ON auth.users IS 'Creates profile record when user signs up';
COMMENT ON TRIGGER on_auth_user_email_changed ON auth.users IS 'Syncs email to profile when changed';
COMMENT ON TRIGGER on_customer_created ON customers IS 'Auto-assigns kunde role when customer record created';
