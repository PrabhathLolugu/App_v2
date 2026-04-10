-- Enable institute-focused document sharing in chat-media bucket.
-- Keeps existing 5 MB limit and private access model.

UPDATE storage.buckets
SET
  file_size_limit = 5242880,
  allowed_mime_types = ARRAY[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'text/csv'
  ]
WHERE id = 'chat-media';

INSERT INTO public.feature_flags (key, description, enabled)
VALUES (
  'chat_documents_enabled',
  'Enable document attachments in chat messages',
  true
)
ON CONFLICT (key) DO UPDATE
SET
  description = EXCLUDED.description,
  enabled = EXCLUDED.enabled,
  updated_at = NOW();
