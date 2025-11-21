# Security & Row Level Security (RLS)

**Version:** 1.0.0
**Last Updated:** 2025-11-21
**Status:** Phase 1 - Complete

---

## Overview

SCHNITTWERK uses a **3-layer security model**:

1. **Database Level (RLS)** - Last line of defense
2. **Server Actions** - Business logic validation
3. **UI** - User experience (never trust for security!)

---

## Architecture

```
┌─────────────────────────────────────┐
│ Layer 3: UI                         │
│ - Hide/disable based on role        │
│ - Better UX, NOT security           │
└───────────────┬─────────────────────┘
                ↓
┌─────────────────────────────────────┐
│ Layer 2: Server Actions             │
│ - Zod validation                    │
│ - Role checks                       │
│ - Business rules                    │
│ - Rate limiting                     │
└───────────────┬─────────────────────┘
                ↓
┌─────────────────────────────────────┐
│ Layer 1: Database RLS (PostgreSQL)  │
│ - salon_id enforcement              │
│ - Role-based policies               │
│ - ALWAYS enforced                   │
│ - Last line of defense              │
└─────────────────────────────────────┘
```

---

## Core Security Principles

### 1. Never Trust the Client
- All user input is validated on server
- salon_id is derived from user_roles, never from client
- RLS enforces access control even if application logic fails

### 2. Multi-Tenant Isolation
- Every business table has `salon_id`
- RLS policies enforce salon scope
- Users cannot access other salons' data
- HQ role explicitly allowed cross-salon access

### 3. Role-Based Access Control (RBAC)
5 roles with hierarchical permissions:
- `kunde` → Customer portal only
- `mitarbeiter` → Staff + calendar access
- `manager` → Full salon operations
- `admin` → Full salon management
- `hq` → Multi-salon overview (salon_id = NULL)

---

## RLS Helper Functions

### auth_user_salon_ids()
Returns list of salon IDs user has access to.

```sql
CREATE FUNCTION auth_user_salon_ids()
RETURNS SETOF UUID AS $$
BEGIN
  RETURN QUERY
  SELECT salon_id
  FROM user_roles
  WHERE profile_id = auth.uid()
    AND salon_id IS NOT NULL;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;
```

### auth_has_role(salon_id, roles[])
Check if user has one of specified roles for salon.

```sql
CREATE FUNCTION auth_has_role(
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
```

### auth_is_hq()
Check if user has HQ role (multi-salon access).

```sql
CREATE FUNCTION auth_is_hq()
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
```

---

## RLS Policies by Table

### salons
**SELECT:**
- Staff/Admin/Manager can view their salons
- HQ can view all salons

**UPDATE:**
- Admin can update their salon

**INSERT:**
- HQ can insert new salons

```sql
CREATE POLICY "salons_select_staff"
  ON salons FOR SELECT
  TO authenticated
  USING (
    id IN (SELECT auth_user_salon_ids())
    OR auth_is_hq()
  );
```

---

### profiles
**SELECT:**
- Users can view own profile
- Staff can view profiles of customers in their salon

**UPDATE:**
- Users can update own profile

**INSERT:**
- Admins/HQ can insert profiles (for staff creation)

```sql
CREATE POLICY "profiles_select_own"
  ON profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid());
```

---

### customers
**SELECT:**
- Customers can view own record
- Staff can view customers in their salon

**UPDATE:**
- Customers can update own record
- Staff can update customers in their salon

**INSERT:**
- Customers can self-register
- Staff can create customer records

```sql
CREATE POLICY "customers_select_own"
  ON customers FOR SELECT
  TO authenticated
  USING (profile_id = auth.uid());

CREATE POLICY "customers_select_staff"
  ON customers FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );
```

---

### staff
**SELECT:**
- Public can view active bookable staff (for booking UI)
- Staff can view all staff in their salon

**UPDATE/DELETE:**
- Admins/Managers only

```sql
CREATE POLICY "staff_select_public"
  ON staff FOR SELECT
  TO authenticated
  USING (is_active = true AND is_bookable_online = true);
```

---

### services & service_categories
**SELECT:**
- Public can view active bookable services
- Staff can view all services in their salon

**ALL:**
- Admins/Managers can manage services

```sql
CREATE POLICY "services_select_public"
  ON services FOR SELECT
  TO authenticated
  USING (is_active = true);

CREATE POLICY "services_all_admin"
  ON services FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin', 'manager']::role_name[]));
```

---

### appointments
**SELECT:**
- Customers can view own appointments
- Staff can view all appointments in their salon

**INSERT:**
- Customers can create appointments (validated by booking rules)
- Staff can create appointments

**UPDATE:**
- Customers can update own appointments (cancel/reschedule)
- Staff can update appointments in their salon

```sql
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

CREATE POLICY "appointments_select_staff"
  ON appointments FOR SELECT
  TO authenticated
  USING (
    salon_id IN (SELECT auth_user_salon_ids())
    AND auth_has_role(salon_id, ARRAY['admin', 'manager', 'mitarbeiter']::role_name[])
  );
```

---

### booking_rules, opening_hours
**SELECT:**
- Public (needed for slot engine)

**ALL:**
- Admins only

```sql
CREATE POLICY "booking_rules_select_public"
  ON booking_rules FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "booking_rules_all_admin"
  ON booking_rules FOR ALL
  TO authenticated
  USING (auth_has_role(salon_id, ARRAY['admin']::role_name[]))
  WITH CHECK (auth_has_role(salon_id, ARRAY['admin']::role_name[]));
```

---

## Double Booking Prevention

### UNIQUE Index (Primary Defense)
```sql
CREATE UNIQUE INDEX idx_appointments_no_double_booking
  ON appointments(salon_id, staff_id, starts_at)
  WHERE status IN ('reserved', 'confirmed', 'requested');
```

This prevents:
- Two appointments for same staff at same start time
- Race conditions even under high concurrency
- Enforced at database level (cannot be bypassed)

### Advisory Lock (Additional Protection)
```sql
CREATE FUNCTION reserve_slot_with_lock(
  p_salon_id UUID,
  p_staff_id UUID,
  p_starts_at TIMESTAMPTZ,
  p_ends_at TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Advisory lock
  PERFORM pg_advisory_xact_lock(
    hashtext(p_salon_id::TEXT || p_staff_id::TEXT || p_starts_at::TEXT)
  );

  -- Check conflicts
  SELECT COUNT(*) INTO v_conflict_count
  FROM appointments
  WHERE salon_id = p_salon_id
    AND staff_id = p_staff_id
    AND status IN ('reserved', 'confirmed', 'requested')
    AND (starts_at < p_ends_at AND ends_at > p_starts_at);

  RETURN v_conflict_count = 0;
END;
$$ LANGUAGE plpgsql;
```

---

## Server-Side Validation

### Example: Create Appointment Server Action
```typescript
// app/actions/appointments.ts
'use server';

import { z } from 'zod';
import { createServerSupabaseClient } from '@/lib/db/supabase-server';

const createAppointmentSchema = z.object({
  salonId: z.string().uuid(),
  customerId: z.string().uuid(),
  staffId: z.string().uuid(),
  startsAt: z.string().datetime(),
  endsAt: z.string().datetime(),
  serviceIds: z.array(z.string().uuid()).min(1),
});

export async function createAppointment(data: unknown) {
  // 1. Validate input
  const validated = createAppointmentSchema.parse(data);

  const supabase = await createServerSupabaseClient();

  // 2. Check if user is customer or staff
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Unauthorized');

  // 3. Verify user has access to this salon
  const { data: userRole } = await supabase
    .from('user_roles')
    .select('role_name')
    .eq('profile_id', user.id)
    .eq('salon_id', validated.salonId)
    .single();

  if (!userRole) throw new Error('No access to this salon');

  // 4. Validate booking rules (lead time, horizon)
  const { data: isValid } = await supabase.rpc('validate_lead_time', {
    p_salon_id: validated.salonId,
    p_starts_at: validated.startsAt,
  });

  if (!isValid) throw new Error('Booking violates lead time rules');

  // 5. Reserve slot atomically
  const { data: slotAvailable } = await supabase.rpc('reserve_slot_with_lock', {
    p_salon_id: validated.salonId,
    p_staff_id: validated.staffId,
    p_starts_at: validated.startsAt,
    p_ends_at: validated.endsAt,
  });

  if (!slotAvailable) throw new Error('Slot not available');

  // 6. Create appointment
  const { data: appointment, error } = await supabase
    .from('appointments')
    .insert({
      salon_id: validated.salonId,
      customer_id: validated.customerId,
      staff_id: validated.staffId,
      starts_at: validated.startsAt,
      ends_at: validated.endsAt,
      status: 'reserved',
      reserved_until: new Date(Date.now() + 15 * 60 * 1000), // 15min
    })
    .select()
    .single();

  if (error) throw error;

  // 7. Add services
  // ... (create appointment_services records)

  return { success: true, appointmentId: appointment.id };
}
```

**Key Validations:**
1. ✅ Zod schema validation
2. ✅ Auth check (user logged in)
3. ✅ Role check (user has access to salon)
4. ✅ Business rules (lead time, horizon)
5. ✅ Atomic slot reservation (lock + conflict check)
6. ✅ RLS enforced automatically on insert

---

## Auth Hardening

### 1. Password Requirements
Configure in Supabase Dashboard:
- Minimum length: 12 characters
- Require uppercase, lowercase, number

### 2. Rate Limiting
Implement rate limiting on:
- Login attempts: 5 per 15min per IP
- Registration: 3 per hour per IP
- Password reset: 3 per hour per email

### 3. Session Management
- JWT expiry: 1 hour
- Refresh token rotation enabled
- Regenerate session after role change
- Optional: Track device sessions

### 4. 2FA (Future)
- TOTP-based 2FA for Admin/Manager
- Recovery codes
- Required for sensitive operations

---

## Audit Logging (Future Phase)

### audit_logs Table
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id),
  actor_profile_id UUID NOT NULL REFERENCES profiles(id),
  action_type TEXT NOT NULL, -- appointment_created, customer_export, etc.
  target_type TEXT, -- appointments, customers, orders
  target_id UUID,
  metadata JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

**Log Events:**
- Customer profile views
- Data exports
- Role changes
- Impersonation
- Critical deletions

---

## Testing RLS

### Unit Tests
```typescript
// tests/rls/appointments.test.ts
describe('Appointments RLS', () => {
  it('customer can only see own appointments', async () => {
    const customer1 = await createTestCustomer('c1@test.ch');
    const customer2 = await createTestCustomer('c2@test.ch');

    const appt1 = await createAppointment({ customerId: customer1.id });
    const appt2 = await createAppointment({ customerId: customer2.id });

    // Login as customer1
    const supabase = createClient(customer1.authToken);
    const { data } = await supabase.from('appointments').select('*');

    expect(data).toHaveLength(1);
    expect(data[0].id).toBe(appt1.id);
  });

  it('staff cannot see other salon appointments', async () => {
    const staff = await createTestStaff('staff@test.ch', 'salon1');
    const appt = await createAppointment({ salonId: 'salon2' });

    const supabase = createClient(staff.authToken);
    const { data } = await supabase.from('appointments').select('*');

    expect(data.find(a => a.id === appt.id)).toBeUndefined();
  });
});
```

---

## Security Checklist

### Phase 1 ✅
- [x] RLS enabled on all tables
- [x] Helper functions for role checks
- [x] Policies for customers, staff, services, appointments
- [x] Double booking prevention
- [x] salon_id enforcement

### Phase 2 (Future)
- [ ] Rate limiting on critical endpoints
- [ ] CSRF protection on forms
- [ ] Content Security Policy (CSP)
- [ ] Audit logging
- [ ] 2FA for admins
- [ ] Session device tracking
- [ ] Penetration testing

---

## Threat Model

### Threats Mitigated
✅ **SQL Injection** - Parameterized queries + Supabase client
✅ **Unauthorized Access** - RLS + role checks
✅ **Cross-Tenant Data Leakage** - salon_id enforcement
✅ **Double Bookings** - UNIQUE index + advisory locks
✅ **Session Hijacking** - Supabase JWT with short expiry

### Threats to Address (Future)
⚠️ **XSS** - Input sanitization, CSP headers
⚠️ **CSRF** - Token validation on state-changing forms
⚠️ **Brute Force** - Rate limiting, account lockout
⚠️ **Clickjacking** - X-Frame-Options, CSP frame-ancestors

---

**See Also:**
- [data-model.md](./data-model.md) - Database schema
- [architecture.md](./architecture.md) - System overview
