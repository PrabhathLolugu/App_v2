-- Create notifications table for in-app notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    
    -- Who triggered the notification
    actor_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    
    -- What type and content
    notification_type notification_type NOT NULL,
    title TEXT,
    body TEXT,
    
    -- Reference to source content
    entity_type TEXT,
    entity_id UUID,
    
    -- Deep link data
    action_url TEXT,
    metadata JSONB DEFAULT '{}',
    
    -- State
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id);
CREATE INDEX idx_notifications_unread ON notifications(recipient_id, is_read) WHERE is_read = false;
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);
CREATE INDEX idx_notifications_recipient_created ON notifications(recipient_id, created_at DESC);;
