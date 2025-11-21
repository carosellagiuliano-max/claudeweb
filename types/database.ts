/**
 * Database Types
 * Generated from Supabase schema
 *
 * To regenerate: supabase gen types typescript --local > types/database.ts
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      salons: {
        Row: {
          id: string;
          name: string;
          slug: string;
          street: string;
          street_number: string | null;
          postal_code: string;
          city: string;
          country: string;
          phone: string | null;
          email: string | null;
          website: string | null;
          instagram_handle: string | null;
          facebook_url: string | null;
          timezone: string;
          currency: string;
          locale: string;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["salons"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["salons"]["Insert"]>;
      };
      profiles: {
        Row: {
          id: string;
          email: string;
          first_name: string | null;
          last_name: string | null;
          phone: string | null;
          birth_date: string | null;
          avatar_url: string | null;
          preferred_language: string | null;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["profiles"]["Row"], "created_at" | "updated_at"> & {
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["profiles"]["Insert"]>;
      };
      user_roles: {
        Row: {
          id: string;
          profile_id: string;
          salon_id: string | null;
          role_name: Database["public"]["Enums"]["role_name"];
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["user_roles"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["user_roles"]["Insert"]>;
      };
      customers: {
        Row: {
          id: string;
          salon_id: string;
          profile_id: string;
          preferred_staff_id: string | null;
          notes: string | null;
          accepts_marketing_email: boolean;
          accepts_marketing_sms: boolean;
          loyalty_tier: string | null;
          total_visits: number;
          total_spend_cents: number;
          is_active: boolean;
          anonymized_at: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["customers"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["customers"]["Insert"]>;
      };
      staff: {
        Row: {
          id: string;
          salon_id: string;
          profile_id: string;
          display_name: string;
          bio: string | null;
          photo_url: string | null;
          position: string | null;
          hire_date: string | null;
          color: string | null;
          sort_order: number;
          is_bookable_online: boolean;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["staff"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["staff"]["Insert"]>;
      };
      services: {
        Row: {
          id: string;
          salon_id: string;
          category_id: string | null;
          name: string;
          slug: string;
          description: string | null;
          base_duration_minutes: number;
          buffer_before_minutes: number;
          buffer_after_minutes: number;
          current_price_cents: number;
          tax_rate_id: string | null;
          image_url: string | null;
          sort_order: number;
          is_bookable_online: boolean;
          requires_deposit: boolean;
          deposit_amount_cents: number | null;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["services"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["services"]["Insert"]>;
      };
      service_categories: {
        Row: {
          id: string;
          salon_id: string;
          name: string;
          slug: string;
          description: string | null;
          icon_name: string | null;
          color: string | null;
          sort_order: number;
          is_active: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["service_categories"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["service_categories"]["Insert"]>;
      };
      appointments: {
        Row: {
          id: string;
          salon_id: string;
          customer_id: string;
          staff_id: string;
          starts_at: string;
          ends_at: string;
          status: Database["public"]["Enums"]["appointment_status"];
          reserved_until: string | null;
          deposit_required: boolean;
          deposit_paid: boolean;
          deposit_amount_cents: number | null;
          total_price_cents: number | null;
          customer_notes: string | null;
          staff_notes: string | null;
          cancelled_at: string | null;
          cancelled_by: string | null;
          cancellation_reason: string | null;
          no_show_marked_at: string | null;
          no_show_fee_charged: boolean | null;
          reminder_sent_at: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["appointments"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["appointments"]["Insert"]>;
      };
      appointment_services: {
        Row: {
          id: string;
          appointment_id: string;
          service_id: string;
          snapshot_service_name: string;
          snapshot_price_cents: number;
          snapshot_tax_rate_percent: number;
          snapshot_duration_minutes: number;
          sort_order: number;
          created_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["appointment_services"]["Row"], "id" | "created_at"> & {
          id?: string;
          created_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["appointment_services"]["Insert"]>;
      };
      booking_rules: {
        Row: {
          id: string;
          salon_id: string;
          min_lead_time_minutes: number;
          max_booking_horizon_days: number;
          cancellation_cutoff_hours: number;
          slot_granularity_minutes: number;
          default_visit_buffer_minutes: number;
          reservation_ttl_minutes: number;
          max_concurrent_reservations: number;
          default_deposit_required: boolean;
          default_deposit_percent: number;
          minimum_deposit_amount_cents: number;
          no_show_policy: Database["public"]["Enums"]["no_show_policy"];
          no_show_fee_cents: number | null;
          allow_multi_service_booking: boolean;
          max_services_per_booking: number;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["booking_rules"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["booking_rules"]["Insert"]>;
      };
      opening_hours: {
        Row: {
          id: string;
          salon_id: string;
          day_of_week: Database["public"]["Enums"]["day_of_week"];
          open_time_minutes: number;
          close_time_minutes: number;
          is_closed: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["opening_hours"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["opening_hours"]["Insert"]>;
      };
      staff_working_hours: {
        Row: {
          id: string;
          staff_id: string;
          day_of_week: Database["public"]["Enums"]["day_of_week"];
          start_time_minutes: number;
          end_time_minutes: number;
          is_day_off: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database["public"]["Tables"]["staff_working_hours"]["Row"], "id" | "created_at" | "updated_at"> & {
          id?: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["staff_working_hours"]["Insert"]>;
      };
    };
    Enums: {
      role_name: "kunde" | "mitarbeiter" | "manager" | "admin" | "hq";
      appointment_status: "reserved" | "requested" | "confirmed" | "completed" | "cancelled" | "no_show";
      no_show_policy: "none" | "charge_deposit" | "charge_full";
      day_of_week: "monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday";
      blocked_time_type: "staff_break" | "staff_meeting" | "salon_closed" | "maintenance" | "other";
    };
  };
}
