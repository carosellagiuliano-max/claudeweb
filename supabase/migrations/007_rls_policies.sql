-- =====================================================
-- Migration 007: Row Level Security (RLS) Policies
-- Description: Security layer enforcing salon_id isolation and role-based access
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- ENABLE RLS ON ALL TABLES
-- =====================================================

ALTER TABLE salons ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_service_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_prices ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE opening_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_working_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_absences ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_times ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_rules ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- HELPER FUNCTION: Get User's Salon IDs
-- =====================================================
CREATE OR REPLACE FUNCTION auth_user_salon_ids()
RETURNS SETOF UUID AS $$
BEGIN
  RETURN QUERY
  SELECT salon_id
  FROM user_roles
  WHERE profile_id = auth.uid()
    AND salon_id IS NOT NULL;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- =====================================================
-- HELPER FUNCTION: Check if User Has Role
-- =====================================================
CREATE OR REPLACE FUNCTION auth_has_role(
  check_salon_id UUID,
  check_roles role_name[]
)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM user_roles
    WHERE profile_id = auth.uid()
      AND salon_id = check_salon_id
      AND role_name = ANY(check_roles)
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- =====================================================
-- HELPER FUNCTION: Check if User is HQ
-- =====================================================
CREATE OR REPLACE FUNCTION auth_is_hq()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM user_roles
    WHERE profile_id = auth.uid()
      AND role_name = 'hq'
      AND salon_id IS NULL
  );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- =====================================================
-- SALONS
-- =====================================================

-- Staff/Admin/Manager can view their salons
CREATE POLICY "salons_select_staff"
  ON salons FOR SELECT
  TO authenticated
  USING (
    id IN (SELECT auth_user_salon_ids())
    OR auth_is_hq()
  );

-- Admins can update their salon
CREATE POLICY "salons_update_admin"
  ON salons FOR UPDATE
  TO authenticated
  USING (auth_has_role(id, ARRAY['admin']::role_name[]))
  WITH CHECK (auth_has_role(id, ARRAY['admin']::role_name[]));

-- HQ can insert salons
CREATE POLICY "salons_insert_hq"
  ON salons FOR INSERT
  TO authenticated
  WITH CHECK (auth_is_hq());

-- =====================================================
-- PROFILES
-- =====================================================

-- Users can view their own profile
CREATE POLICY "profiles_select_own"
  ON profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid());

-- Staff can view profiles of customers in their salon
CREATE POLICY "profiles_select_staff"
  ON profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customers c
      JOIN user_roles ur ON ur.salon_id = c.salon_id
      WHERE c.profile_id = profiles.id
        AND ur.profile_id = auth.uid()
        AND ur.role_name IN ('admin', 'manager', 'mitarbeiter')
    )
  );

-- Users can update their own profile
CREATE POLICY "profiles_update_own"
  ON profiles FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- Profiles are created by trigger, no manual insert
-- Admins can insert profiles for staff
CREATE POLICY "profiles_insert_admin"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE profile_id = auth.uid()
        AND role_name IN ('admin', 'hq')
    )
  );

-- =====================================================
-- USER_ROLES
-- =====================================================

-- Users can view their own roles
CREATE POLICY "user_roles_select_own"
  ON user_roles FOR SELECT
  TO authenticated
  USING (profile_id = auth.uid());

-- Admins can view roles in their salon
CREATE POLICY "user_roles_select_admin"
  ON user_roles FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[])
  );

-- Admins can manage roles in their salon
CREATE POLICY "user_roles_insert_admin"
  ON user_roles FOR INSERT
  TO authenticated
  WITH CHECK (
    auth_has_role(salon_id, ARRAY['admin']::role_name[])
  );

CREATE POLICY "user_roles_update_admin"
  ON user_roles FOR UPDATE
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin']::role_name[]));

CREATE POLICY "user_roles_delete_admin"
  ON user_roles FOR DELETE
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin']::role_name[]));

-- =====================================================
-- CUSTOMERS
-- =====================================================

-- Customers can view their own record
CREATE POLICY "customers_select_own"
  ON customers FOR SELECT
  TO authenticated
  USING (profile_id = auth.uid());

-- Staff can view customers in their salon
CREATE POLICY "customers_select_staff"
  ON customers FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Customers can update their own record
CREATE POLICY "customers_update_own"
  ON customers FOR UPDATE
  TO authenticated
  USING (profile_id = auth.uid())
  WITH CHECK (profile_id = auth.uid());

-- Staff can update customers in their salon
CREATE POLICY "customers_update_staff"
  ON customers FOR UPDATE
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Customers can be created during registration
CREATE POLICY "customers_insert_any"
  ON customers FOR INSERT
  TO authenticated
  WITH CHECK (profile_id = auth.uid() OR auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

-- =====================================================
-- STAFF
-- =====================================================

-- Anyone can view active bookable staff (for booking UI)
CREATE POLICY "staff_select_public"
  ON staff FOR SELECT
  TO authenticated
  USING (is_active = true AND is_bookable_online = true);

-- Staff can view all staff in their salon
CREATE POLICY "staff_select_staff"
  ON staff FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Admins can manage staff
CREATE POLICY "staff_insert_admin"
  ON staff FOR INSERT
  TO authenticated
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

CREATE POLICY "staff_update_admin"
  ON staff FOR UPDATE
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

CREATE POLICY "staff_delete_admin"
  ON staff FOR DELETE
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin']::role_name[]));

-- =====================================================
-- SERVICES (PUBLIC READ)
-- =====================================================

-- Anyone can view active bookable services
CREATE POLICY "services_select_public"
  ON services FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Staff can view all services in their salon
CREATE POLICY "services_select_staff"
  ON services FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
  );

-- Admins can manage services
CREATE POLICY "services_all_admin"
  ON services FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

-- =====================================================
-- SERVICE CATEGORIES (PUBLIC READ)
-- =====================================================

CREATE POLICY "service_categories_select_public"
  ON service_categories FOR SELECT
  TO authenticated
  USING (is_active = true);

CREATE POLICY "service_categories_all_admin"
  ON service_categories FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

-- =====================================================
-- APPOINTMENTS
-- =====================================================

-- Customers can view their own appointments
CREATE POLICY "appointments_select_customer"
  ON appointments FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customers c
      WHERE c.id = appointments.customer_id
        AND c.profile_id = auth.uid()
    )
  );

-- Staff can view all appointments in their salon
CREATE POLICY "appointments_select_staff"
  ON appointments FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Customers can create appointments (through booking flow)
CREATE POLICY "appointments_insert_customer"
  ON appointments FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM customers c
      WHERE c.id = customer_id
        AND c.profile_id = auth.uid()
        AND c.salon_id = salon_id
    )
  );

-- Staff can create appointments
CREATE POLICY "appointments_insert_staff"
  ON appointments FOR INSERT
  TO authenticated
  WITH CHECK (
    auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Customers can update their own appointments (cancel/reschedule)
CREATE POLICY "appointments_update_customer"
  ON appointments FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customers c
      WHERE c.id = appointments.customer_id
        AND c.profile_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM customers c
      WHERE c.id = appointments.customer_id
        AND c.profile_id = auth.uid()
    )
  );

-- Staff can update appointments in their salon
CREATE POLICY "appointments_update_staff"
  ON appointments FOR UPDATE
  TO authenticated
  USING (
    auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- =====================================================
-- OPENING HOURS, SCHEDULES, RULES (PUBLIC READ)
-- =====================================================

-- Opening hours are public
CREATE POLICY "opening_hours_select_public"
  ON opening_hours FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "opening_hours_all_admin"
  ON opening_hours FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));

-- Booking rules are public (for slot engine)
CREATE POLICY "booking_rules_select_public"
  ON booking_rules FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "booking_rules_all_admin"
  ON booking_rules FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin']::role_name[]));

-- =====================================================
-- REMAINING TABLES (STAFF ACCESS ONLY)
-- =====================================================

-- Staff working hours, absences, blocked times - staff can view their own
CREATE POLICY "staff_working_hours_select_own"
  ON staff_working_hours FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM staff s
      WHERE s.id = staff_working_hours.staff_id
        AND s.profile_id = auth.uid()
    )
  );

CREATE POLICY "staff_working_hours_all_admin"
  ON staff_working_hours FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM staff s
      WHERE s.id = staff_working_hours.staff_id
        AND auth_has_role(s.salon_id, ARRAY['admin', 'manager']::role_name[])
    )
  );

-- Similar policies for staff_absences, blocked_times, etc.
CREATE POLICY "staff_absences_all_admin"
  ON staff_absences FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM staff s
      WHERE s.id = staff_absences.staff_id
        AND auth_has_role(s.salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
    )
  );

CREATE POLICY "blocked_times_all_admin"
  ON blocked_times FOR ALL
  TO authenticated
  USING (
    auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );

-- Service prices - read for staff, write for admin
CREATE POLICY "service_prices_select_staff"
  ON service_prices FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM services s
      WHERE s.id = service_prices.service_id
        AND s.salon_id IN (SELECT auth_user_salon_ids())
    )
  );

CREATE POLICY "service_prices_all_admin"
  ON service_prices FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM services s
      WHERE s.id = service_prices.service_id
        AND auth_has_role(s.salon_id, ARRAY['admin', 'manager']::role_name[])
    )
  );

-- Staff service skills
CREATE POLICY "staff_service_skills_select_public"
  ON staff_service_skills FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM staff s
      WHERE s.id = staff_service_skills.staff_id
        AND s.is_active = true
    )
  );

CREATE POLICY "staff_service_skills_all_admin"
  ON staff_service_skills FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM staff s
      WHERE s.id = staff_service_skills.staff_id
        AND auth_has_role(s.salon_id, ARRAY['admin', 'manager']::role_name[])
    )
  );

-- Appointment services - same as appointments
CREATE POLICY "appointment_services_select_customer"
  ON appointment_services FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM appointments a
      JOIN customers c ON c.id = a.customer_id
      WHERE a.id = appointment_services.appointment_id
        AND c.profile_id = auth.uid()
    )
  );

CREATE POLICY "appointment_services_select_staff"
  ON appointment_services FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM appointments a
      WHERE a.id = appointment_services.appointment_id
        AND auth_has_role(a.salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
    )
  );

CREATE POLICY "appointment_services_insert_any"
  ON appointment_services FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM appointments a
      WHERE a.id = appointment_id
        AND (
          EXISTS (
            SELECT 1 FROM customers c
            WHERE c.id = a.customer_id AND c.profile_id = auth.uid()
          )
          OR auth_has_role(a.salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
        )
    )
  );

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON FUNCTION auth_user_salon_ids IS 'Get list of salon IDs user has access to based on user_roles';
COMMENT ON FUNCTION auth_has_role IS 'Check if current user has one of the specified roles for a salon';
COMMENT ON FUNCTION auth_is_hq IS 'Check if current user has HQ role (multi-salon access)';
