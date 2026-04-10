-- Convenience view for one-call reads.

CREATE OR REPLACE VIEW public.fabric_hubs_with_sellers AS
SELECT
    h.*,
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id', s.id,
          'fabric_hub_id', s.fabric_hub_id,
          'seller_name', s.seller_name,
          'organization', s.organization,
          'seller_type', s.seller_type,
          'contact_line', s.contact_line,
          'website', s.website,
          'city', s.city,
          'is_featured', s.is_featured,
          'display_order', s.display_order
        )
        ORDER BY s.display_order, s.created_at
      ) FILTER (WHERE s.id IS NOT NULL),
      '[]'::jsonb
    ) AS sellers
FROM public.fabric_hubs h
LEFT JOIN public.fabric_sellers s
  ON s.fabric_hub_id = h.id
GROUP BY h.id;

