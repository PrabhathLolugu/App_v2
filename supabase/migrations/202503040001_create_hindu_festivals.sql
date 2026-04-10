-- Hindu Festivals table for Indian Festivals section (home + detail)
CREATE TABLE IF NOT EXISTS public.hindu_festivals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  short_description text,
  description text,
  when_celebrated text,
  when_details text,
  where_celebrated text,
  how_celebrated text,
  history text,
  significance text,
  scriptures_related text,
  image_url text,
  order_index int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS
ALTER TABLE public.hindu_festivals ENABLE ROW LEVEL SECURITY;

-- Public read (no insert/update/delete for anon; data is admin-maintained)
CREATE POLICY "Allow public read hindu_festivals"
  ON public.hindu_festivals
  FOR SELECT
  USING (true);

-- Optional: allow authenticated service role to manage (for future admin)
-- CREATE POLICY "Allow service role all" ON public.hindu_festivals FOR ALL USING (auth.role() = 'service_role');

COMMENT ON TABLE public.hindu_festivals IS 'Hindu festivals for Indian Festivals section; read-only for app.';
