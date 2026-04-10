-- Migration: Add plan versioning and travel modes tracking to saved_travel_plans

-- Add plan_version_history column to track version history
ALTER TABLE public.saved_travel_plans 
ADD COLUMN IF NOT EXISTS plan_version_history JSONB DEFAULT '[]'::jsonb;

-- Add travel_modes column to track detected travel modes (train, flight, bus, hotel, car)
ALTER TABLE public.saved_travel_plans 
ADD COLUMN IF NOT EXISTS travel_modes TEXT[] DEFAULT '{}'::text[];

-- Create index on travel_modes for faster filtering
CREATE INDEX IF NOT EXISTS idx_saved_travel_plans_travel_modes
    ON public.saved_travel_plans
    USING GIN (travel_modes);

-- Add comment to document the plan_version_history structure
COMMENT ON COLUMN public.saved_travel_plans.plan_version_history IS 
'Array of plan versions: [{version: 1, plan_text: "...", created_at: "2026-04-05T10:00:00Z", change_notes: "Initial plan"}]';

COMMENT ON COLUMN public.saved_travel_plans.travel_modes IS 
'Array of detected travel modes: ["train", "flight", "bus", "hotel", "car"]';
