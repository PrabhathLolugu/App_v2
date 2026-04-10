-- Add shared_content_id column to chat_messages table
ALTER TABLE public.chat_messages 
ADD COLUMN IF NOT EXISTS shared_content_id uuid NULL,
ADD COLUMN IF NOT EXISTS type text NULL;

-- Optional: Create index for better performance if querying by shared content
CREATE INDEX IF NOT EXISTS idx_chat_messages_shared_content_id 
ON public.chat_messages (shared_content_id);
