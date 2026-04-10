-- Supabase database linter:
--   0007 policy_exists_rls_disabled / 0013 rls_disabled_in_public → conversation_members
--   0010 security_definer_view → craft_hubs_with_sellers, food_hubs_with_items
--
-- conversation_members: policies already exist in DB; RLS was disabled in 20260318_004 for debugging.
-- Hub views: PG15+ default is security definer; use security_invoker so RLS applies as the querying role.

ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE VIEW public.craft_hubs_with_sellers
WITH (security_invoker = true) AS
SELECT
    ch.*,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', cs.id,
                    'craft_hub_id', cs.craft_hub_id,
                    'seller_name', cs.seller_name,
                    'organization', cs.organization,
                    'seller_type', cs.seller_type,
                    'contact_line', cs.contact_line,
                    'website', cs.website,
                    'city', cs.city,
                    'is_featured', cs.is_featured,
                    'display_order', cs.display_order
                )
                ORDER BY cs.display_order ASC
            )
            FROM public.craft_sellers cs
            WHERE cs.craft_hub_id = ch.id
        ),
        '[]'::jsonb
    ) AS sellers
FROM public.craft_hubs ch;

GRANT SELECT ON public.craft_hubs_with_sellers TO authenticated, anon, service_role;

CREATE OR REPLACE VIEW public.food_hubs_with_items
WITH (security_invoker = true) AS
SELECT
    h.id,
    h.slug,
    h.state_code,
    h.state_name,
    h.latitude,
    h.longitude,
    h.pin_hide_zoom_max,
    h.sort_order,
    h.is_published,
    h.created_at,
    h.updated_at,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', i.id,
                    'food_name', i.food_name,
                    'short_description', i.short_description,
                    'about_food', i.about_food,
                    'history', i.history,
                    'ingredients', i.ingredients,
                    'preparation_style', i.preparation_style,
                    'serving_context', i.serving_context,
                    'nutrition_notes', i.nutrition_notes,
                    'best_season', i.best_season,
                    'discussion_site_id', i.discussion_site_id,
                    'cover_image_url', i.cover_image_url,
                    'gallery_urls', i.gallery_urls,
                    'sort_order', i.sort_order,
                    'is_published', i.is_published
                )
                ORDER BY i.sort_order, i.food_name
            )
            FROM public.food_state_items i
            WHERE i.hub_id = h.id AND i.is_published = TRUE
        ),
        '[]'::jsonb
    ) AS items
FROM public.food_state_hubs h
WHERE h.is_published = TRUE;

GRANT SELECT ON public.food_hubs_with_items TO anon, authenticated, service_role;
