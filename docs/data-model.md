# Data Model

**Version:** 1.0.0
**Last Updated:** 2025-11-21
**Status:** Phase 1 - Complete

---

## Overview

This document describes the complete database schema for SCHNITTWERK. The schema is designed to be **multi-tenant from day 1** with `salon_id` on all business tables.

---

## Key Principles

### 1. Multi-Tenant Architecture
Every business table includes `salon_id` to enable:
- Clean data isolation
- Future multi-salon support without rewrites
- Salon-scoped RLS policies

### 2. Audit Trail
All tables include:
- `created_at` - Timestamp of creation
- `updated_at` - Auto-updated by trigger

### 3. Soft Deletes (Where Needed)
Some tables use `is_active` or `deleted_at` instead of hard deletes to preserve audit trails.

### 4. Price History
Services and products store price changes separately to maintain historical accuracy.

---

## Core Tables

### salons
Physical salon locations.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| name | TEXT | Salon name (e.g., "SCHNITTWERK by Vanessa Carosella") |
| slug | TEXT | URL-friendly identifier |
| street | TEXT | Street name |
| street_number | TEXT | Street number |
| postal_code | TEXT | Postal code |
| city | TEXT | City |
| country | TEXT | Country code (default: CH) |
| phone | TEXT | Contact phone |
| email | TEXT | Contact email |
| timezone | TEXT | IANA timezone (default: Europe/Zurich) |
| currency | TEXT | ISO 4217 code (default: CHF) |
| locale | TEXT | Locale (default: de-CH) |
| is_active | BOOLEAN | Whether salon is active |

**Indexes:**
- `idx_salons_active` on `is_active`

---

### profiles
Extended user profile data linked to `auth.users`.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | FK to auth.users.id |
| email | TEXT | Email address (synced from auth) |
| first_name | TEXT | First name |
| last_name | TEXT | Last name |
| phone | TEXT | Phone number |
| birth_date | DATE | Date of birth |
| avatar_url | TEXT | Avatar image URL |
| preferred_language | TEXT | Language preference (de, fr, it, en) |
| is_active | BOOLEAN | Whether profile is active |

**Auto-created:** Profile is automatically created by trigger when user signs up via Supabase Auth.

**Indexes:**
- `idx_profiles_email` on `email`
- `idx_profiles_active` on `is_active`

---

### roles & user_roles
Role-based access control (RBAC).

**Roles:**
- `kunde` - Customer (portal access)
- `mitarbeiter` - Staff (calendar, limited admin)
- `manager` - Manager (full salon operations)
- `admin` - Admin (full system access)
- `hq` - HQ (multi-salon overview, `salon_id` = NULL)

**user_roles:**
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| profile_id | UUID | FK to profiles |
| salon_id | UUID | FK to salons (NULL for HQ role) |
| role_name | ENUM | Role assignment |

**Constraint:** `UNIQUE(profile_id, salon_id, role_name)`

---

## Customer & Staff

### customers
Customer records.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| profile_id | UUID | FK to profiles |
| preferred_staff_id | UUID | FK to staff (nullable) |
| notes | TEXT | Internal staff notes |
| accepts_marketing_email | BOOLEAN | Email marketing consent |
| accepts_marketing_sms | BOOLEAN | SMS marketing consent |
| loyalty_tier | TEXT | Loyalty tier (standard, silver, gold, platinum) |
| total_visits | INTEGER | Cached visit count |
| total_spend_cents | INTEGER | Cached lifetime spend in cents |
| is_active | BOOLEAN | Whether customer is active |
| anonymized_at | TIMESTAMPTZ | GDPR deletion timestamp |

**Constraint:** `UNIQUE(salon_id, profile_id)`

---

### staff
Staff members.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| profile_id | UUID | FK to profiles |
| display_name | TEXT | Public-facing name |
| bio | TEXT | Biography |
| photo_url | TEXT | Profile photo |
| position | TEXT | Job title (e.g., "Senior Stylist") |
| hire_date | DATE | Hire date |
| color | TEXT | Calendar color (hex) |
| sort_order | INTEGER | Display order |
| is_bookable_online | BOOLEAN | Can be booked online |
| is_active | BOOLEAN | Whether staff is active |

**Constraint:** `UNIQUE(salon_id, profile_id)`

---

### staff_service_skills
Junction table mapping staff to services they can perform.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| staff_id | UUID | FK to staff |
| service_id | UUID | FK to services |
| proficiency_level | TEXT | Skill level (standard, advanced, expert) |

**Constraint:** `UNIQUE(staff_id, service_id)`

---

## Services

### service_categories
Service categories (e.g., Haircuts, Coloring, Styling).

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| name | TEXT | Category name |
| slug | TEXT | URL-friendly name |
| description | TEXT | Description |
| icon_name | TEXT | Lucide icon name |
| color | TEXT | Hex color |
| sort_order | INTEGER | Display order |
| is_active | BOOLEAN | Whether active |

---

### services
Services offered by salon.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| category_id | UUID | FK to service_categories |
| name | TEXT | Service name |
| slug | TEXT | URL-friendly name |
| description | TEXT | Description |
| base_duration_minutes | INTEGER | Core duration |
| buffer_before_minutes | INTEGER | Prep time |
| buffer_after_minutes | INTEGER | Cleanup time |
| current_price_cents | INTEGER | Current price (cached) |
| is_bookable_online | BOOLEAN | Can be booked online |
| requires_deposit | BOOLEAN | Requires deposit |
| deposit_amount_cents | INTEGER | Deposit amount (nullable) |
| is_active | BOOLEAN | Whether active |

**Effective Duration:** `base_duration + buffer_before + buffer_after`

---

### service_prices
Price history for services.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| service_id | UUID | FK to services |
| price_cents | INTEGER | Price in cents |
| tax_rate_percent | NUMERIC(5,2) | Tax rate at time |
| valid_from | TIMESTAMPTZ | Effective from |
| valid_to | TIMESTAMPTZ | Effective until (NULL = current) |
| notes | TEXT | Reason for change |

**Current Price:** `valid_to IS NULL`

---

## Appointments

### appointments
Booking records with race condition prevention.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| customer_id | UUID | FK to customers |
| staff_id | UUID | FK to staff |
| starts_at | TIMESTAMPTZ | Start time |
| ends_at | TIMESTAMPTZ | End time |
| status | ENUM | Status (see below) |
| reserved_until | TIMESTAMPTZ | Expiry for reserved status |
| deposit_required | BOOLEAN | Deposit required |
| deposit_paid | BOOLEAN | Deposit paid |
| deposit_amount_cents | INTEGER | Deposit amount |
| total_price_cents | INTEGER | Total (cached from services) |
| customer_notes | TEXT | Customer notes |
| staff_notes | TEXT | Internal notes |
| cancelled_at | TIMESTAMPTZ | Cancellation time |
| cancelled_by | UUID | FK to profiles |
| cancellation_reason | TEXT | Reason |
| no_show_marked_at | TIMESTAMPTZ | No-show timestamp |
| no_show_fee_charged | BOOLEAN | Fee charged |
| reminder_sent_at | TIMESTAMPTZ | Reminder sent |

**Status Enum:**
- `reserved` - Temp hold (15min TTL)
- `requested` - Needs confirmation
- `confirmed` - Paid if required
- `completed` - Service done
- `cancelled` - Cancelled
- `no_show` - Customer missed

**CRITICAL INDEX:** `UNIQUE(salon_id, staff_id, starts_at)` WHERE `status IN ('reserved', 'confirmed', 'requested')`
→ Prevents double bookings at DB level

---

### appointment_services
Services in appointment with snapshot pricing.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| appointment_id | UUID | FK to appointments |
| service_id | UUID | FK to services |
| snapshot_service_name | TEXT | Name at booking time |
| snapshot_price_cents | INTEGER | Price at booking time |
| snapshot_tax_rate_percent | NUMERIC(5,2) | Tax rate at booking time |
| snapshot_duration_minutes | INTEGER | Duration at booking time |
| sort_order | INTEGER | Order for multi-service |

---

## Schedules & Availability

### opening_hours
Regular weekly opening hours.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| day_of_week | ENUM | monday to sunday |
| open_time_minutes | INTEGER | Minutes since midnight (0-1439) |
| close_time_minutes | INTEGER | Minutes since midnight (0-1440) |
| is_closed | BOOLEAN | Whether salon closed this day |

**Why minutes?** Avoids DST issues. Stored as local time offset.

---

### staff_working_hours
Regular weekly working hours per staff.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| staff_id | UUID | FK to staff |
| day_of_week | ENUM | monday to sunday |
| start_time_minutes | INTEGER | Minutes since midnight |
| end_time_minutes | INTEGER | Minutes since midnight |
| is_day_off | BOOLEAN | Whether staff off this day |

---

### staff_absences
One-time absences (vacation, sick leave).

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| staff_id | UUID | FK to staff |
| start_date | DATE | Start date |
| end_date | DATE | End date (inclusive) |
| reason | TEXT | Reason (e.g., "Vacation", "Sick") |
| notes | TEXT | Internal notes |

---

### blocked_times
One-time blocks (breaks, meetings, closures).

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| salon_id | UUID | FK to salons |
| staff_id | UUID | FK to staff (NULL = salon-wide) |
| starts_at | TIMESTAMPTZ | Start time |
| ends_at | TIMESTAMPTZ | End time |
| block_type | ENUM | Type (staff_break, meeting, salon_closed, maintenance, other) |
| reason | TEXT | Reason |
| notes | TEXT | Internal notes |
| is_recurring | BOOLEAN | Whether recurring (future use) |
| recurrence_rule | TEXT | iCal RRULE (future use) |

---

## Booking Rules

### booking_rules
Per-salon booking configuration.

| Column | Type | Default | Description |
|--------|------|---------|-------------|
| id | UUID | | Primary key |
| salon_id | UUID | | FK to salons (UNIQUE) |
| min_lead_time_minutes | INTEGER | 60 | Min time before appointment |
| max_booking_horizon_days | INTEGER | 90 | Max days in advance |
| cancellation_cutoff_hours | INTEGER | 24 | Free cancellation cutoff |
| slot_granularity_minutes | INTEGER | 15 | Slot increment (15, 30, 60) |
| default_visit_buffer_minutes | INTEGER | 0 | Buffer between visits |
| reservation_ttl_minutes | INTEGER | 15 | Temp reservation duration |
| max_concurrent_reservations | INTEGER | 3 | Max active reservations per customer |
| default_deposit_required | BOOLEAN | false | Deposit required by default |
| default_deposit_percent | NUMERIC | 20.00 | Deposit % of total |
| minimum_deposit_amount_cents | INTEGER | 1000 | Min deposit (CHF 10.00) |
| no_show_policy | ENUM | none | none, charge_deposit, charge_full |
| no_show_fee_cents | INTEGER | NULL | Fixed no-show fee |
| allow_multi_service_booking | BOOLEAN | true | Multi-service allowed |
| max_services_per_booking | INTEGER | 5 | Max services per appointment |

---

## Helper Functions

### Slot Engine Functions

```sql
-- Check if booking within lead time
validate_lead_time(salon_id, starts_at) → BOOLEAN

-- Check if booking within horizon
validate_booking_horizon(salon_id, starts_at) → BOOLEAN

-- Check if cancellation allowed
validate_cancellation_cutoff(salon_id, starts_at) → BOOLEAN

-- Check reservation limit
validate_reservation_limit(salon_id, customer_id) → BOOLEAN

-- Calculate deposit
calculate_deposit_amount(salon_id, total_cents) → INTEGER

-- Atomic slot reservation with lock
reserve_slot_with_lock(salon_id, staff_id, starts_at, ends_at) → BOOLEAN

-- Check staff availability
is_staff_available(staff_id, starts_at, ends_at) → BOOLEAN

-- Clean expired reservations (cron job)
clean_expired_reservations() → INTEGER
```

---

## Row Level Security (RLS)

All tables have RLS enabled with policies based on:
- User's role (`kunde`, `mitarbeiter`, `manager`, `admin`, `hq`)
- Salon scope (users can only access their assigned salons)
- HQ role has cross-salon access

**Helper Functions:**
```sql
auth_user_salon_ids() → SETOF UUID
auth_has_role(salon_id, roles[]) → BOOLEAN
auth_is_hq() → BOOLEAN
```

**Policy Examples:**
- Customers can view own appointments
- Staff can view all appointments in their salon
- Admins can manage everything in their salon
- HQ can view all salons

See [security-and-rls.md](./security-and-rls.md) for full policies.

---

## Next Steps

**Phase 2:** Tax rates, products, orders, payments, vouchers, loyalty
**Phase 3:** Notifications, consent, audit logs
**Phase 4:** Analytics views, reporting

---

## Diagram

```
┌──────────┐
│  salons  │
└────┬─────┘
     │
     ├─── service_categories
     ├─── services ──── service_prices
     ├─── opening_hours
     ├─── booking_rules
     ├─── customers ──── profiles ──── auth.users
     ├─── staff ──────── profiles
     │         │
     │         ├─── staff_working_hours
     │         ├─── staff_absences
     │         └─── staff_service_skills
     │
     └─── appointments ──── appointment_services
              │
              ├─── blocked_times
              └─── user_roles
```

---

**For detailed security policies:** See [security-and-rls.md](./security-and-rls.md)
**For API usage:** See [dev-setup.md](./dev-setup.md)
