# SCHNITTWERK by Vanessa Carosella

Modern digital system for a Swiss hair salon - from online booking to complete admin backend.

## 🎯 Project Overview

SCHNITTWERK is a production-ready, multi-tenant salon management system built for Swiss market compliance (DSG, GDPR, Swiss accounting rules).

### Features

- 🗓️ **Online Booking** - Customer-facing booking system with real-time slot availability
- 🛍️ **E-Commerce** - Product shop with cart, checkout, and Stripe payments (CHF)
- 👥 **Customer Portal** - Self-service dashboard for appointments, orders, and loyalty
- 🎛️ **Admin Backend** - Complete salon operations management
- 💳 **Payments** - Stripe integration with Swiss francs (CHF) and Twint support
- 📧 **Notifications** - Email system via Resend with customizable templates
- 🔐 **Security** - Row-Level Security (RLS), RBAC, 3-layer authorization
- 📊 **Analytics** - Revenue tracking, staff performance, inventory management
- 🏢 **Multi-Salon Ready** - Architecture supports multiple salons from day 1

## 🚀 Tech Stack

- **Frontend:** Next.js 14+ (App Router), React, TypeScript
- **Styling:** Tailwind CSS, shadcn/ui
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth
- **Payments:** Stripe
- **Email:** Resend
- **Monitoring:** Sentry
- **Deployment:** Vercel

## 📦 Getting Started

### Prerequisites

- Node.js 20+
- pnpm (recommended) or npm

### Installation

```bash
# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env.local

# Start development server
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Setup Instructions

See [docs/dev-setup.md](./docs/dev-setup.md) for detailed setup instructions.

## 📖 Documentation

- [Architecture Overview](./docs/architecture.md) - System architecture and design decisions
- [Data Model](./docs/data-model.md) - Complete database schema documentation
- [Security & RLS](./docs/security-and-rls.md) - Security policies and access control
- [Development Setup](./docs/dev-setup.md) - Local development instructions
- [Full Specification](./claude.md) - Complete product and technical specification

## 🏗️ Project Status

**Current Phase:** Phase 2 - Design System Expansion ✅

### Phase 0 - Foundation ✅
- [x] Next.js 14 setup with TypeScript
- [x] Tailwind CSS + shadcn/ui design system
- [x] Project structure and folder organization
- [x] Modern UI components (Header, Footer, Homepage)
- [x] Base documentation

### Phase 1 - Database & Auth ✅
- [x] Complete database schema (8 migrations)
  - Core tables (salons, profiles, roles, user_roles)
  - Customers & staff management
  - Services & categories with price history
  - Appointments with double-booking prevention
  - Schedules & availability (opening hours, staff schedules, absences)
  - Booking rules & configuration
  - Row-Level Security (RLS) policies
  - Auth triggers & profile sync
- [x] TypeScript type definitions
- [x] Supabase client library setup
- [x] Seed script with test data
- [x] Comprehensive documentation

### Phase 2 - Design System Expansion ✅
- [x] Additional UI components (Card, Input, Label, Badge, Avatar, Skeleton, Textarea)
- [x] Feature components (ServiceCard, TeamCard)
- [x] Services page (/leistungen) with all service offerings
- [x] Team page (/team) with staff profiles

**Next Phase:** Phase 3 - Additional Public Pages (Über uns, Kontakt, Legal pages)

## 🛠️ Development

```bash
# Development server
pnpm dev

# Type checking
pnpm type-check

# Linting
pnpm lint

# Testing
pnpm test

# Build for production
pnpm build
```

## 🎨 Design System

Modern luxury salon aesthetic with:
- Clean, minimalist interface
- Generous white space
- Glass-morphism effects
- Gold accent colors
- Swiss design principles

## 🔒 Security & Compliance

- **Swiss DSG & GDPR compliant** - Data protection and privacy
- **Row-Level Security (RLS)** - Database-level access control
- **Multi-layer authorization** - DB, Server, UI
- **Audit logging** - Full activity tracking
- **10-year retention** - Swiss accounting requirements

## 📄 License

Private - SCHNITTWERK by Vanessa Carosella

## 👥 Team

Built with Claude Code following software engineering best practices for production systems.

---

**Location:** Rorschacherstrasse 152, 9000 St. Gallen, Switzerland