/**
 * Shared Supabase Client Configuration
 */
import { createClient } from "jsr:@supabase/supabase-js@2";

/**
 * Create a Supabase admin client using service role key (bypasses RLS)
 * Use this for database operations in Edge Functions
 */
export function createSupabaseClient() {
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !supabaseServiceKey) {
    throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  }

  // Service role client bypasses RLS for trusted server-side operations
  return createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}
