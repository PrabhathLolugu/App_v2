/**
 * Shared TypeScript Types
 */

// Story Generation Types
export interface StoryOptions {
  story_type?: string;
  theme?: string;
  main_character?: string;
  setting?: string;
  length?: string;
  language?: string;
}

export interface StoryRequest {
  prompt: string;
  scripture?: string;
  options?: StoryOptions;
  use_vedabase?: boolean;
  vedabase_source?: string;
  vedabase_top_k?: number;
}

export interface StoryResponse {
  title: string;
  story: string;
  moral: string;
  reference: string;
  characters: string[];
  story_id?: string;
}

// Chat Types
export type ChatMode = "friend" | "philosophical" | "auto" | "tourist_guide" | "story_scholar";

export interface ChatMessage {
  role: "user" | "assistant" | "system";
  content: string;
}

export interface ChatRequest {
  chat_id?: string;
  story_id?: string;
  message: string;
  mode: ChatMode;
  language?: string;
  user_id?: string;
  title?: string;
  story_content?: string;
  moral?: string;
  user_name?: string;
}

export interface ChatResponse {
  response: string;
  chat_id: string;
  suggestions?: string[];
}

// Translation Types
export interface TranslationRequest {
  title: string;
  story: string;
  moral: string;
  target_lang:
    | "en"
    | "hi"
    | "te"
    | "ta"
    | "bn"
    | "mr"
    | "gu"
    | "kn"
    | "ml"
    | "pa"
    | "or"
    | "ur"
    | "sa"
    | "as";
}

export interface TranslationResponse {
  title: string;
  story: string;
  moral: string;
  lang: string;
}

// Image Generation Types
export interface ImageGenerationRequest {
  story_id?: string;
  title?: string;
  story_content?: string;
}

export interface ImageGenerationResponse {
  image_url: string;
  prompt?: string;
}

// Database Types
export interface GeneratedStory {
  id: string;
  user_id: string;
  title: string;
  story_content: string;
  moral: string | null;
  source: string | null;
  characters: string[] | null;
  image_url: string | null;
  is_featured: boolean;
  created_at: string;
  updated_at: string;
}

export interface StoryChat {
  id: string;
  story_id: string;
  user_id: string;
  messages: ChatMessage[];
  created_at: string;
  updated_at: string;
}

// Error Response
export interface ErrorResponse {
  error: string;
  details?: unknown;
}
