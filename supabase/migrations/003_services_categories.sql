-- =====================================================
-- Migration 003: Services & Categories
-- Description: Service catalog with pricing history
-- Author: Claude Code
-- Date: 2025-11-21
-- =====================================================

-- =====================================================
-- SERVICE CATEGORIES
-- =====================================================
CREATE TABLE service_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,

  -- Category Info
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,

  -- Display
  icon_name TEXT, -- Lucide icon name
  color TEXT, -- Hex color for UI
  sort_order INTEGER NOT NULL DEFAULT 0,

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(salon_id, slug)
);

-- Indexes
CREATE INDEX idx_service_categories_salon ON service_categories(salon_id);
CREATE INDEX idx_service_categories_active ON service_categories(salon_id, is_active) WHERE is_active = true;

CREATE TRIGGER update_service_categories_updated_at
  BEFORE UPDATE ON service_categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- SERVICES
-- =====================================================
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  salon_id UUID NOT NULL REFERENCES salons(id) ON DELETE CASCADE,
  category_id UUID REFERENCES service_categories(id) ON DELETE SET NULL,

  -- Service Info
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,

  -- Duration (in minutes)
  base_duration_minutes INTEGER NOT NULL CHECK (base_duration_minutes > 0),
  buffer_before_minutes INTEGER NOT NULL DEFAULT 0 CHECK (buffer_before_minutes >= 0),
  buffer_after_minutes INTEGER NOT NULL DEFAULT 0 CHECK (buffer_after_minutes >= 0),

  -- Pricing
  -- Current price stored here for quick access
  current_price_cents INTEGER NOT NULL CHECK (current_price_cents >= 0),

  -- Tax (link to tax_rates table in later migration)
  tax_rate_id UUID, -- FK added later

  -- Display
  image_url TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,

  -- Booking Settings
  is_bookable_online BOOLEAN NOT NULL DEFAULT true,
  requires_deposit BOOLEAN NOT NULL DEFAULT false,
  deposit_amount_cents INTEGER, -- NULL means use salon default

  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  UNIQUE(salon_id, slug)
);

-- Indexes
CREATE INDEX idx_services_salon ON services(salon_id);
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_services_active ON services(salon_id, is_active) WHERE is_active = true;
CREATE INDEX idx_services_bookable ON services(salon_id, is_bookable_online) WHERE is_bookable_online = true;

CREATE TRIGGER update_services_updated_at
  BEFORE UPDATE ON services
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- SERVICE PRICES
-- =====================================================
-- Price history for services
-- Allows tracking price changes over time
CREATE TABLE service_prices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,

  -- Price
  price_cents INTEGER NOT NULL CHECK (price_cents >= 0),

  -- Tax Rate (snapshot)
  tax_rate_percent NUMERIC(5, 2) NOT NULL CHECK (tax_rate_percent >= 0),

  -- Validity Period
  valid_from TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valid_to TIMESTAMPTZ, -- NULL means currently active

  -- Metadata
  notes TEXT, -- Reason for price change

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CHECK (valid_to IS NULL OR valid_to > valid_from)
);

-- Indexes
CREATE INDEX idx_service_prices_service ON service_prices(service_id);
CREATE INDEX idx_service_prices_current ON service_prices(service_id, valid_from, valid_to)
  WHERE valid_to IS NULL;

-- =====================================================
-- Add FK constraint to staff_service_skills
-- =====================================================
ALTER TABLE staff_service_skills
  ADD CONSTRAINT fk_staff_service_skills_service
  FOREIGN KEY (service_id)
  REFERENCES services(id)
  ON DELETE CASCADE;

-- =====================================================
-- FUNCTION: Get Current Service Price
-- =====================================================
CREATE OR REPLACE FUNCTION get_service_current_price(p_service_id UUID)
RETURNS INTEGER AS $$
DECLARE
  v_price_cents INTEGER;
BEGIN
  SELECT price_cents INTO v_price_cents
  FROM service_prices
  WHERE service_id = p_service_id
    AND valid_from <= NOW()
    AND (valid_to IS NULL OR valid_to > NOW())
  ORDER BY valid_from DESC
  LIMIT 1;

  -- Fallback to service.current_price_cents if no price history
  IF v_price_cents IS NULL THEN
    SELECT current_price_cents INTO v_price_cents
    FROM services
    WHERE id = p_service_id;
  END IF;

  RETURN v_price_cents;
END;
$$ LANGUAGE plpgsql STABLE;

-- =====================================================
-- TRIGGER: Update service.current_price_cents
-- =====================================================
-- When a new service_price is inserted, update the service's current_price_cents
CREATE OR REPLACE FUNCTION update_service_current_price()
RETURNS TRIGGER AS $$
BEGIN
  -- Only update if this is the new current price (valid_to IS NULL)
  IF NEW.valid_to IS NULL THEN
    UPDATE services
    SET current_price_cents = NEW.price_cents,
        updated_at = NOW()
    WHERE id = NEW.service_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_service_current_price
  AFTER INSERT ON service_prices
  FOR EACH ROW
  EXECUTE FUNCTION update_service_current_price();

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE service_categories IS 'Service categories (e.g., Haircut, Coloring, Styling)';
COMMENT ON TABLE services IS 'Services offered by salon. Prices tracked separately for history.';
COMMENT ON TABLE service_prices IS 'Price history for services. Allows price changes without losing history.';

COMMENT ON COLUMN services.base_duration_minutes IS 'Core duration of service without buffers';
COMMENT ON COLUMN services.buffer_before_minutes IS 'Buffer time before appointment (e.g., for preparation)';
COMMENT ON COLUMN services.buffer_after_minutes IS 'Buffer time after appointment (e.g., for cleanup)';
COMMENT ON COLUMN services.current_price_cents IS 'Cached current price in cents. Auto-updated from service_prices.';
COMMENT ON COLUMN service_prices.valid_from IS 'Price becomes effective at this timestamp';
COMMENT ON COLUMN service_prices.valid_to IS 'NULL means currently active price, otherwise end of validity';
