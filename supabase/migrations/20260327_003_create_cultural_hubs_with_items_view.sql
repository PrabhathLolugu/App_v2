CREATE OR REPLACE VIEW public.cultural_hubs_with_items AS
SELECT
    h.*,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', i.id,
                    'hub_id', i.hub_id,
                    'item_name', i.item_name,
                    'short_description', i.short_description,
                    'about_state_tradition', i.about_state_tradition,
                    'history', i.history,
                    'cultural_significance', i.cultural_significance,
                    'practice_and_pedagogy', i.practice_and_pedagogy,
                    'performance_context', i.performance_context,
                    'notable_exponents', i.notable_exponents,
                    'discussion_site_id', i.discussion_site_id,
                    'cover_image_url', i.cover_image_url,
                    'gallery_urls', i.gallery_urls,
                    'sort_order', i.sort_order,
                    'is_published', i.is_published
                )
                ORDER BY i.sort_order ASC
            )
            FROM public.cultural_state_items i
            WHERE i.hub_id = h.id AND i.is_published = TRUE
        ),
        '[]'::jsonb
    ) AS items
FROM public.cultural_state_hubs h
WHERE h.is_published = TRUE;

GRANT SELECT ON public.cultural_hubs_with_items TO authenticated, anon, service_role;

