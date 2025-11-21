-- =====================================================
-- Seed Script 001: Initial Test Data
-- Description: Create test salon with admin, staff, and services
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- 1. CREATE SALON
-- =====================================================

INSERT INTO salons (
  id,
  name,
  slug,
  street,
  street_number,
  postal_code,
  city,
  country,
  phone,
  email,
  timezone,
  currency,
  locale,
  is_active
) VALUES (
  '00000000-0000-0000-0000-000000000001'::UUID,
  'SCHNITTWERK by Vanessa Carosella',
  'schnittwerk-stgallen',
  'Rorschacherstrasse',
  '152',
  '9000',
  'St. Gallen',
  'CH',
  '+41 71 234 56 78',
  'info@schnittwerk.ch',
  'Europe/Zurich',
  'CHF',
  'de-CH',
  true
) ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 2. CREATE SERVICE CATEGORIES
-- =====================================================

INSERT INTO service_categories (id, salon_id, name, slug, description, icon_name, sort_order, is_active) VALUES
  ('10000000-0000-0000-0000-000000000001'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'Haarschnitte', 'haarschnitte', 'Professionelle Haarschnitte für Damen, Herren und Kinder', 'Scissors', 1, true),
  ('10000000-0000-0000-0000-000000000002'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'Färbungen', 'faerbungen', 'Haarfärbungen, Strähnchen und Colorationen', 'Palette', 2, true),
  ('10000000-0000-0000-0000-000000000003'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'Styling', 'styling', 'Föhnen, Locken und Hochsteckfrisuren', 'Sparkles', 3, true)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 3. CREATE SERVICES
-- =====================================================

INSERT INTO services (
  id,
  salon_id,
  category_id,
  name,
  slug,
  description,
  base_duration_minutes,
  buffer_before_minutes,
  buffer_after_minutes,
  current_price_cents,
  is_bookable_online,
  is_active,
  sort_order
) VALUES
  -- Haarschnitte
  (
    '20000000-0000-0000-0000-000000000001'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '10000000-0000-0000-0000-000000000001'::UUID,
    'Damenhaarschnitt',
    'damenhaarschnitt',
    'Professioneller Haarschnitt für Damen inkl. Waschen und Föhnen',
    60,
    0,
    5,
    7500, -- CHF 75.00
    true,
    true,
    1
  ),
  (
    '20000000-0000-0000-0000-000000000002'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '10000000-0000-0000-0000-000000000001'::UUID,
    'Herrenhaarschnitt',
    'herrenhaarschnitt',
    'Moderner Herrenhaarschnitt inkl. Waschen',
    45,
    0,
    5,
    5500, -- CHF 55.00
    true,
    true,
    2
  ),
  (
    '20000000-0000-0000-0000-000000000003'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '10000000-0000-0000-0000-000000000001'::UUID,
    'Kinderhaarschnitt',
    'kinderhaarschnitt',
    'Haarschnitt für Kinder bis 12 Jahre',
    30,
    0,
    5,
    3500, -- CHF 35.00
    true,
    true,
    3
  ),

  -- Färbungen
  (
    '20000000-0000-0000-0000-000000000004'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '10000000-0000-0000-0000-000000000002'::UUID,
    'Komplettfärbung',
    'komplettfaerbung',
    'Komplette Haarfärbung inkl. Pflege und Styling',
    120,
    10,
    10,
    14500, -- CHF 145.00
    true,
    true,
    4
  ),
  (
    '20000000-0000-0000-0000-000000000005'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '10000000-0000-0000-0000-000000000002'::UUID,
    'Strähnchen',
    'straehnchen',
    'Feine Strähnchen für natürliche Highlights',
    90,
    5,
    10,
    12000, -- CHF 120.00
    true,
    true,
    5
  )
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 4. CREATE SERVICE PRICES (Price History)
-- =====================================================

-- Initial prices for all services
INSERT INTO service_prices (service_id, price_cents, tax_rate_percent, valid_from, valid_to) VALUES
  ('20000000-0000-0000-0000-000000000001'::UUID, 7500, 8.1, NOW(), NULL),
  ('20000000-0000-0000-0000-000000000002'::UUID, 5500, 8.1, NOW(), NULL),
  ('20000000-0000-0000-0000-000000000003'::UUID, 3500, 8.1, NOW(), NULL),
  ('20000000-0000-0000-0000-000000000004'::UUID, 14500, 8.1, NOW(), NULL),
  ('20000000-0000-0000-0000-000000000005'::UUID, 12000, 8.1, NOW(), NULL)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 5. CREATE BOOKING RULES
-- =====================================================

INSERT INTO booking_rules (
  salon_id,
  min_lead_time_minutes,
  max_booking_horizon_days,
  cancellation_cutoff_hours,
  slot_granularity_minutes,
  default_visit_buffer_minutes,
  reservation_ttl_minutes,
  max_concurrent_reservations,
  default_deposit_required,
  default_deposit_percent,
  minimum_deposit_amount_cents,
  no_show_policy,
  allow_multi_service_booking,
  max_services_per_booking
) VALUES (
  '00000000-0000-0000-0000-000000000001'::UUID,
  60,      -- 1 hour lead time
  90,      -- 90 days booking horizon
  24,      -- 24 hours cancellation cutoff
  15,      -- 15 minute slot granularity
  5,       -- 5 minute buffer between visits
  15,      -- 15 minute reservation TTL
  3,       -- Max 3 concurrent reservations
  false,   -- No deposit required by default
  20.00,   -- 20% deposit if required
  1000,    -- Min CHF 10.00 deposit
  'none',  -- No no-show penalty
  true,    -- Allow multi-service bookings
  5        -- Max 5 services per booking
) ON CONFLICT (salon_id) DO NOTHING;

-- =====================================================
-- 6. CREATE OPENING HOURS
-- =====================================================

-- Monday to Friday: 09:00 - 18:00
INSERT INTO opening_hours (salon_id, day_of_week, open_time_minutes, close_time_minutes, is_closed) VALUES
  ('00000000-0000-0000-0000-000000000001'::UUID, 'monday', 540, 1080, false),    -- 09:00 - 18:00
  ('00000000-0000-0000-0000-000000000001'::UUID, 'tuesday', 540, 1080, false),
  ('00000000-0000-0000-0000-000000000001'::UUID, 'wednesday', 540, 1080, false),
  ('00000000-0000-0000-0000-000000000001'::UUID, 'thursday', 540, 1080, false),
  ('00000000-0000-0000-0000-000000000001'::UUID, 'friday', 540, 1080, false),
  ('00000000-0000-0000-0000-000000000001'::UUID, 'saturday', 540, 960, false),   -- 09:00 - 16:00
  ('00000000-0000-0000-0000-000000000001'::UUID, 'sunday', 0, 0, true)           -- Closed
ON CONFLICT (salon_id, day_of_week) DO NOTHING;

-- =====================================================
-- 7. CREATE TEST USERS & PROFILES
-- =====================================================

-- Note: In real usage, users are created via Supabase Auth signup
-- Profiles are auto-created by trigger
-- This seed shows the expected structure

-- Admin User (example - in reality created via auth)
-- INSERT INTO auth.users (id, email) VALUES ('30000000-0000-0000-0000-000000000001'::UUID, 'admin@schnittwerk.ch');
-- Profile auto-created by trigger

-- For testing, we'll create profiles directly
INSERT INTO profiles (id, email, first_name, last_name, is_active) VALUES
  ('30000000-0000-0000-0000-000000000001'::UUID, 'admin@schnittwerk.ch', 'Vanessa', 'Carosella', true),
  ('30000000-0000-0000-0000-000000000002'::UUID, 'staff1@schnittwerk.ch', 'Maria', 'Müller', true),
  ('30000000-0000-0000-0000-000000000003'::UUID, 'staff2@schnittwerk.ch', 'Anna', 'Schmidt', true),
  ('30000000-0000-0000-0000-000000000004'::UUID, 'kunde@example.com', 'Max', 'Mustermann', true)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 8. CREATE STAFF
-- =====================================================

INSERT INTO staff (
  id,
  salon_id,
  profile_id,
  display_name,
  bio,
  position,
  color,
  sort_order,
  is_bookable_online,
  is_active
) VALUES
  (
    '40000000-0000-0000-0000-000000000001'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '30000000-0000-0000-0000-000000000001'::UUID,
    'Vanessa Carosella',
    'Inhaberin und Master Stylistin mit über 15 Jahren Erfahrung',
    'Inhaberin / Master Stylist',
    '#EC4899', -- Pink
    1,
    true,
    true
  ),
  (
    '40000000-0000-0000-0000-000000000002'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '30000000-0000-0000-0000-000000000002'::UUID,
    'Maria Müller',
    'Spezialistin für Färbungen und Colorationen',
    'Senior Stylist',
    '#3B82F6', -- Blue
    2,
    true,
    true
  ),
  (
    '40000000-0000-0000-0000-000000000003'::UUID,
    '00000000-0000-0000-0000-000000000001'::UUID,
    '30000000-0000-0000-0000-000000000003'::UUID,
    'Anna Schmidt',
    'Expertin für Herrenhaarschnitte und Styling',
    'Stylist',
    '#10B981', -- Green
    3,
    true,
    true
  )
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 9. CREATE STAFF WORKING HOURS
-- =====================================================

-- Vanessa: Monday-Friday 09:00-18:00, Saturday 09:00-16:00
INSERT INTO staff_working_hours (staff_id, day_of_week, start_time_minutes, end_time_minutes, is_day_off) VALUES
  ('40000000-0000-0000-0000-000000000001'::UUID, 'monday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'tuesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'wednesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'thursday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'friday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'saturday', 540, 960, false),
  ('40000000-0000-0000-0000-000000000001'::UUID, 'sunday', 0, 0, true)
ON CONFLICT (staff_id, day_of_week) DO NOTHING;

-- Maria: Tuesday-Saturday 09:00-18:00
INSERT INTO staff_working_hours (staff_id, day_of_week, start_time_minutes, end_time_minutes, is_day_off) VALUES
  ('40000000-0000-0000-0000-000000000002'::UUID, 'monday', 0, 0, true),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'tuesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'wednesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'thursday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'friday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'saturday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000002'::UUID, 'sunday', 0, 0, true)
ON CONFLICT (staff_id, day_of_week) DO NOTHING;

-- Anna: Monday-Friday 09:00-18:00
INSERT INTO staff_working_hours (staff_id, day_of_week, start_time_minutes, end_time_minutes, is_day_off) VALUES
  ('40000000-0000-0000-0000-000000000003'::UUID, 'monday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'tuesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'wednesday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'thursday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'friday', 540, 1080, false),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'saturday', 0, 0, true),
  ('40000000-0000-0000-0000-000000000003'::UUID, 'sunday', 0, 0, true)
ON CONFLICT (staff_id, day_of_week) DO NOTHING;

-- =====================================================
-- 10. CREATE STAFF SERVICE SKILLS
-- =====================================================

-- Vanessa can do all services
INSERT INTO staff_service_skills (staff_id, service_id, proficiency_level) VALUES
  ('40000000-0000-0000-0000-000000000001'::UUID, '20000000-0000-0000-0000-000000000001'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000001'::UUID, '20000000-0000-0000-0000-000000000002'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000001'::UUID, '20000000-0000-0000-0000-000000000003'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000001'::UUID, '20000000-0000-0000-0000-000000000004'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000001'::UUID, '20000000-0000-0000-0000-000000000005'::UUID, 'expert')
ON CONFLICT (staff_id, service_id) DO NOTHING;

-- Maria specializes in färbungen
INSERT INTO staff_service_skills (staff_id, service_id, proficiency_level) VALUES
  ('40000000-0000-0000-0000-000000000002'::UUID, '20000000-0000-0000-0000-000000000001'::UUID, 'advanced'),
  ('40000000-0000-0000-0000-000000000002'::UUID, '20000000-0000-0000-0000-000000000004'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000002'::UUID, '20000000-0000-0000-0000-000000000005'::UUID, 'expert')
ON CONFLICT (staff_id, service_id) DO NOTHING;

-- Anna focuses on haircuts
INSERT INTO staff_service_skills (staff_id, service_id, proficiency_level) VALUES
  ('40000000-0000-0000-0000-000000000003'::UUID, '20000000-0000-0000-0000-000000000001'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000003'::UUID, '20000000-0000-0000-0000-000000000002'::UUID, 'expert'),
  ('40000000-0000-0000-0000-000000000003'::UUID, '20000000-0000-0000-0000-000000000003'::UUID, 'expert')
ON CONFLICT (staff_id, service_id) DO NOTHING;

-- =====================================================
-- 11. CREATE USER ROLES
-- =====================================================

-- Vanessa is admin
INSERT INTO user_roles (profile_id, salon_id, role_name) VALUES
  ('30000000-0000-0000-0000-000000000001'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'admin')
ON CONFLICT (profile_id, salon_id, role_name) DO NOTHING;

-- Maria is mitarbeiter
INSERT INTO user_roles (profile_id, salon_id, role_name) VALUES
  ('30000000-0000-0000-0000-000000000002'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'mitarbeiter')
ON CONFLICT (profile_id, salon_id, role_name) DO NOTHING;

-- Anna is mitarbeiter
INSERT INTO user_roles (profile_id, salon_id, role_name) VALUES
  ('30000000-0000-0000-0000-000000000003'::UUID, '00000000-0000-0000-0000-000000000001'::UUID, 'mitarbeiter')
ON CONFLICT (profile_id, salon_id, role_name) DO NOTHING;

-- =====================================================
-- 12. CREATE TEST CUSTOMER
-- =====================================================

INSERT INTO customers (
  id,
  salon_id,
  profile_id,
  accepts_marketing_email,
  accepts_marketing_sms,
  is_active
) VALUES (
  '50000000-0000-0000-0000-000000000001'::UUID,
  '00000000-0000-0000-0000-000000000001'::UUID,
  '30000000-0000-0000-0000-000000000004'::UUID,
  true,
  false,
  true
) ON CONFLICT (salon_id, profile_id) DO NOTHING;

-- Kunde role auto-assigned by trigger

-- =====================================================
-- SEED COMPLETE
-- =====================================================

SELECT 'Seed completed successfully! Created:' AS status;
SELECT COUNT(*) AS salons FROM salons;
SELECT COUNT(*) AS profiles FROM profiles;
SELECT COUNT(*) AS staff FROM staff;
SELECT COUNT(*) AS services FROM services;
SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS user_roles FROM user_roles;
