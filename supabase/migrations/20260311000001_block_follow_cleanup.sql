-- Ensure follow relationships are removed in both directions whenever a block is created,
-- and clean up any existing follows between users who have already blocked each other.

CREATE OR REPLACE FUNCTION cleanup_follows_on_block()
RETURNS TRIGGER AS $$
BEGIN
    -- Remove follows where the blocker follows the blocked user
    -- and where the blocked user follows the blocker.
    DELETE FROM follows
    WHERE (follower_id = NEW.blocker_id AND following_id = NEW.blocked_id)
       OR (follower_id = NEW.blocked_id AND following_id = NEW.blocker_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_cleanup_follows_on_block ON user_blocks;

CREATE TRIGGER trigger_cleanup_follows_on_block
AFTER INSERT ON user_blocks
FOR EACH ROW
EXECUTE FUNCTION cleanup_follows_on_block();

-- One-time cleanup for existing data: remove any follow relationships
-- between users who have already blocked each other.
DELETE FROM follows f
USING user_blocks b
WHERE (f.follower_id = b.blocker_id AND f.following_id = b.blocked_id)
   OR (f.follower_id = b.blocked_id AND f.following_id = b.blocker_id);

-- Optional helper: block a user and clean up follows in a single RPC call.
-- This can be used by the application instead of inserting directly into user_blocks.
CREATE OR REPLACE FUNCTION block_user_and_cleanup(blocked uuid)
RETURNS void AS $$
DECLARE
    current_user_id uuid;
BEGIN
    current_user_id := auth.uid();

    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated' USING HINT = 'auth.uid() returned null';
    END IF;

    -- Prevent self-block
    IF current_user_id = blocked THEN
        RETURN;
    END IF;

    -- Insert block if it does not already exist
    INSERT INTO user_blocks (blocker_id, blocked_id)
    VALUES (current_user_id, blocked)
    ON CONFLICT (blocker_id, blocked_id) DO NOTHING;

    -- Cleanup any follow relationships in either direction.
    DELETE FROM follows
    WHERE (follower_id = current_user_id AND following_id = blocked)
       OR (follower_id = blocked AND following_id = current_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


