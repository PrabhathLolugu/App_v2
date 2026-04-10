-- Enable chat image sharing and link preview feature flags for all existing installs.
-- Migration 202603170004 seeded these as disabled; this migration activates them.
UPDATE public.feature_flags
SET enabled = true, updated_at = NOW()
WHERE key IN ('chat_images_enabled', 'chat_link_preview_enabled');
