CREATE OR REPLACE VIEW public.food_hubs_with_items AS
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

