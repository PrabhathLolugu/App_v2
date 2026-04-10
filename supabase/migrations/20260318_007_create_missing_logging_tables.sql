-- Migration: Create missing logging and admin tables
-- Date: 2026-03-18
-- Description: Creates tables for system logging, auditing, user management, and warning tracking

-- ============================================================================
-- user_roles table - User role assignments (service_role + admin only)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    assigned_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, role)
);

-- Add missing columns if user_roles table already exists
ALTER TABLE IF EXISTS public.user_roles
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.user_roles
ADD COLUMN IF NOT EXISTS role TEXT;

ALTER TABLE IF EXISTS public.user_roles
ADD COLUMN IF NOT EXISTS assigned_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE IF EXISTS public.user_roles
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

-- Index for user roles
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON public.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON public.user_roles(role);

-- ============================================================================
-- api_logs table - Track API calls for monitoring and debugging
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.api_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    status_code INT,
    response_time_ms INT,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    error_message TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if api_logs table already exists
ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS endpoint TEXT;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS method TEXT;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS status_code INT;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS response_time_ms INT;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS error_message TEXT;

ALTER TABLE IF EXISTS public.api_logs
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

-- Index for api logs
CREATE INDEX IF NOT EXISTS idx_api_logs_endpoint ON public.api_logs(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_logs_created_at ON public.api_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_logs_status_code ON public.api_logs(status_code);

-- ============================================================================
-- user_warnings table - Track user policy violations and warnings
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_warnings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    warning_type TEXT NOT NULL,
    reason TEXT,
    severity TEXT DEFAULT 'low',
    resolved BOOLEAN DEFAULT false,
    resolved_at TIMESTAMPTZ,
    issued_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if user_warnings table already exists
ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS warning_type TEXT;

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS reason TEXT;

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS severity TEXT DEFAULT 'low';

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS resolved BOOLEAN DEFAULT false;

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;

ALTER TABLE IF EXISTS public.user_warnings
ADD COLUMN IF NOT EXISTS issued_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;

-- Index for user warnings
CREATE INDEX IF NOT EXISTS idx_user_warnings_user_id ON public.user_warnings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_warnings_created_at ON public.user_warnings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_warnings_resolved ON public.user_warnings(resolved);

-- ============================================================================
-- epistemic_logs table - Track data quality and verification events
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.epistemic_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    content_id UUID,
    content_type TEXT,
    data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if epistemic_logs table already exists
ALTER TABLE IF EXISTS public.epistemic_logs
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.epistemic_logs
ADD COLUMN IF NOT EXISTS event_type TEXT;

ALTER TABLE IF EXISTS public.epistemic_logs
ADD COLUMN IF NOT EXISTS content_id UUID;

ALTER TABLE IF EXISTS public.epistemic_logs
ADD COLUMN IF NOT EXISTS content_type TEXT;

ALTER TABLE IF EXISTS public.epistemic_logs
ADD COLUMN IF NOT EXISTS data JSONB DEFAULT '{}';

-- Index for epistemic logs
CREATE INDEX IF NOT EXISTS idx_epistemic_logs_event_type ON public.epistemic_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_epistemic_logs_created_at ON public.epistemic_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_epistemic_logs_content ON public.epistemic_logs(content_type, content_id);

-- ============================================================================
-- audit_log table - Comprehensive audit trail for compliance and debugging
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action TEXT NOT NULL,
    table_name TEXT,
    record_id UUID,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if audit_log table already exists
ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS action TEXT;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS table_name TEXT;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS record_id UUID;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS old_values JSONB;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS new_values JSONB;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS ip_address INET;

ALTER TABLE IF EXISTS public.audit_log
ADD COLUMN IF NOT EXISTS user_agent TEXT;

-- Index for audit log
CREATE INDEX IF NOT EXISTS idx_audit_log_action ON public.audit_log(action);
CREATE INDEX IF NOT EXISTS idx_audit_log_table_name ON public.audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_user_id ON public.audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON public.audit_log(created_at DESC);
