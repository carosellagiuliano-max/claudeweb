# Development Setup

**Last Updated:** 2025-11-21

This guide helps you set up SCHNITTWERK for local development.

---

## Prerequisites

- **Node.js:** 20.x or higher
- **Package Manager:** npm, pnpm, or yarn (we recommend pnpm)
- **Supabase CLI:** For local database development
- **Git:** Version control

---

## Initial Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd claudeweb
```

### 2. Install Dependencies

```bash
# Using pnpm (recommended)
pnpm install

# Or using npm
npm install

# Or using yarn
yarn install
```

### 3. Environment Variables

Copy the example environment file:

```bash
cp .env.example .env.local
```

Fill in the values (see [Environment Variables](#environment-variables) below).

---

## Running Locally

### Start Development Server

```bash
npm run dev
```

The app will be available at [http://localhost:3000](http://localhost:3000).

### Type Checking

```bash
npm run type-check
```

### Linting

```bash
npm run lint
```

---

## Environment Variables

### Supabase

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

**How to get these:**
1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Go to Project Settings → API
3. Copy the URL and keys

### Stripe (Test Mode)

```bash
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

**How to get these:**
1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Go to Developers → API keys
3. Use **Test mode** for development

### Resend

```bash
RESEND_API_KEY=re_...
```

**How to get this:**
1. Create an account at [resend.com](https://resend.com)
2. Go to API Keys
3. Create a new key

### Sentry

```bash
NEXT_PUBLIC_SENTRY_DSN=https://...@sentry.io/...
SENTRY_AUTH_TOKEN=...
```

**How to get these:**
1. Create a Sentry account at [sentry.io](https://sentry.io)
2. Create a new project
3. Copy the DSN

### App URL

```bash
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development
```

---

## Supabase Local Development

### Install Supabase CLI

**macOS:**
```bash
brew install supabase/tap/supabase
```

**Other platforms:**
See [Supabase CLI docs](https://supabase.com/docs/guides/cli).

### Initialize Local Supabase

```bash
supabase init
supabase start
```

This starts a local Postgres database, Auth server, and Storage.

### Link to Remote Project

```bash
supabase link --project-ref <your-project-ref>
```

### Run Migrations

Once you have migrations (Phase 1+):

```bash
supabase db push
```

### Generate TypeScript Types

```bash
supabase gen types typescript --local > types/supabase.ts
```

---

## Testing

### Run Tests

```bash
npm run test
```

### Run Tests with UI

```bash
npm run test:ui
```

### Coverage Report

```bash
npm run test:coverage
```

---

## Common Tasks

### Add a New Component

```bash
# Example: Add a Dialog component
npx shadcn-ui@latest add dialog
```

### Format Code

```bash
npx prettier --write .
```

### Database Migrations

When you create a new migration (Phase 1+):

```bash
supabase migration new migration_name
```

Edit the generated SQL file in `supabase/migrations/`.

---

## Troubleshooting

### Port Already in Use

If port 3000 is already in use:

```bash
# Kill the process
lsof -ti:3000 | xargs kill -9

# Or use a different port
PORT=3001 npm run dev
```

### Supabase Connection Issues

Make sure your local Supabase is running:

```bash
supabase status
```

If not running:

```bash
supabase start
```

### Type Errors

Regenerate Supabase types:

```bash
supabase gen types typescript --local > types/supabase.ts
```

---

## Phase 1 Setup (Coming Soon)

Once we implement Phase 1 (Database & Auth):

1. Run initial migrations
2. Seed test data
3. Configure RLS policies
4. Test auth flows

Instructions will be added here.

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |
| `npm run type-check` | Run TypeScript compiler |
| `npm run test` | Run tests |
| `supabase start` | Start local Supabase |
| `supabase stop` | Stop local Supabase |
| `supabase status` | Check Supabase status |

---

## Need Help?

- Check [architecture.md](./architecture.md) for system overview
- Check [claude.md](../claude.md) for detailed specifications
- Create an issue in the repository
