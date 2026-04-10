-- Add deleted_at column to conversation_members for soft delete functionality
-- This allows users to "delete" conversations without actually removing data
-- Messages sent after deleted_at will still be visible

ALTER TABLE conversation_members 
ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL;

-- Add index for performance when filtering deleted conversations
CREATE INDEX idx_conversation_members_deleted_at 
ON conversation_members(user_id, deleted_at) 
WHERE deleted_at IS NOT NULL;

-- Add comment for documentation
COMMENT ON COLUMN conversation_members.deleted_at IS 
'Timestamp when user soft-deleted this conversation. Messages after this time are still visible.';
