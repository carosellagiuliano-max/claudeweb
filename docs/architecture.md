# SCHNITTWERK Architecture

**Version:** 0.1.0
**Last Updated:** 2025-11-21
**Status:** Phase 0 - Foundation

---

## Executive Summary

SCHNITTWERK ist ein vollständiges digitales System für einen modernen Schweizer Friseursalon. Von Tag 1 multi-salon-fähig, produktionsreif für Jahre, Swiss DSG/GDPR-compliant.

### Tech Stack

- **Frontend:** Next.js 14+ (App Router), React, TypeScript
- **Styling:** Tailwind CSS, shadcn/ui
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth
- **Payments:** Stripe (CHF, Twint)
- **Email:** Resend
- **Monitoring:** Sentry
- **Deployment:** Vercel

---

## Architecture Principles

### 1. Multi-Tenant from Day 1

**Every business table has `salon_id`** to enable future multi-salon support without rewrites.

```typescript
interface BaseEntity {
  id: string;
  salon_id: string;  // CRITICAL: Never forget this
  created_at: Date;
  updated_at: Date;
}
```

### 2. Security-First (3 Layers)

```
┌─────────────────────────────────────┐
│ 1. RLS (Database Level)             │ ← Last line of defense
│    ✓ salon_id enforcement           │
│    ✓ role-based access              │
└─────────────────────────────────────┘
           ↑
┌─────────────────────────────────────┐
│ 2. Server Actions (Business Logic)  │ ← Validation & Authorization
│    ✓ Zod schemas                    │
│    ✓ Rate limiting                  │
│    ✓ Role checks                    │
└─────────────────────────────────────┘
           ↑
┌─────────────────────────────────────┐
│ 3. UI (User Experience)             │ ← Hide/Disable only
│    ✓ Conditional rendering          │
│    ✗ NEVER trust for security       │
└─────────────────────────────────────┘
```

### 3. Configuration-Driven

- Business data (services, prices, hours) in database
- Business rules and invariants in code
- Admin can manage almost everything through UI

### 4. Idempotency Everywhere

All critical operations (bookings, payments, vouchers, loyalty) are idempotent to handle retries safely.

---

## Project Structure

```
/
├── app/
│   ├── (public)/          # Public-facing pages
│   ├── (customer)/        # Customer portal
│   ├── (admin)/           # Admin backend
│   └── api/               # API routes & webhooks
├── components/
│   ├── ui/                # shadcn/ui primitives
│   └── shared/            # Shared components
├── features/              # Domain features
│   ├── booking/           # Booking engine
│   ├── shop/              # E-commerce
│   ├── loyalty/           # Loyalty program
│   └── notifications/     # Email & SMS
├── lib/                   # Core libraries
│   ├── db/                # Supabase client
│   ├── domain/            # Domain logic
│   ├── validators/        # Zod schemas
│   └── payments/          # Stripe integration
├── supabase/
│   ├── migrations/        # SQL migrations
│   └── seed/              # Seed data
├── docs/                  # Documentation
└── tests/                 # Test suites
```

---

## Key Design Decisions

### Slot Engine: Compute, Don't Store

Slots are **computed on-demand** from constraints (opening hours, staff schedules, existing appointments) rather than stored.

**Rationale:** Flexibility, no stale data, easier to add new constraints.

### Payment Flow: Reserve → Pay → Confirm

1. Create appointment (status: `reserved`, 15min TTL)
2. Create Stripe Payment Intent with `appointment_id` in metadata
3. Webhook confirms → status `confirmed`
4. Idempotency via `stripe_event_log.event_id` (UNIQUE)

### Compliance: Pseudonymization, Not Deletion

On GDPR deletion request:
- Name → "Gelöschter Kunde #12345"
- Email → "deleted+12345@schnittwerk.local"
- Invoices remain (10-year retention requirement)

---

## Current Status (Phase 0)

✅ Next.js 14 project setup
✅ Folder structure
✅ Tailwind + shadcn/ui integration
✅ Modern design system (luxury salon theme)
✅ Public layout (Header, Footer)
✅ Homepage with hero and info cards

**Next:** Phase 1 - Database schema & Supabase Auth

---

## See Also

- [dev-setup.md](./dev-setup.md) - Local development instructions
- [data-model.md](./data-model.md) - Database schema (coming in Phase 1)
- [security-and-rls.md](./security-and-rls.md) - RLS policies (coming in Phase 1)
