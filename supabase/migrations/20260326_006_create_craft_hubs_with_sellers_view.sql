CREATE OR REPLACE VIEW public.craft_hubs_with_sellers AS
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

