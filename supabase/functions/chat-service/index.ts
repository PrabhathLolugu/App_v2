import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import {
  analyzePhilosophicalUserState,
  analyzeUserIntentForTouristGuide,
  extractFallbackCallName,
  extractPreferredCallNameFromText,
  extractSuggestionsFromLlmResponse,
  generateDynamicSuggestions,
  getSafetyContext,
  hasHarmfulContent,
  padSuggestions,
  resolveEffectiveCallName,
} from "../_shared/chat_helpers.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { chatWithHistory, type ChatMessage as OpenRouterMessage, type GenerationConfig } from "../_shared/openrouter.ts";

// Override model for chat service
const CHAT_MODEL = "google/gemma-4-26b-adb-it";
import { retryWithBackoff } from "../_shared/retry.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";
import type { ChatMessage, ChatMode } from "../_shared/types.ts";

/**
 * Chat Service Edge Function
 *
 * Handles conversational AI with different personas:
 * - friend: Krishna as a caring friend
 * - philosophical: Krishna from Bhagavad Gita
 * - tourist_guide: Heritage site guide
 * - story_scholar: Scripture expert
 */

interface ChatRequest {
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

interface StoryChatContext {
  history: ChatMessage[];
  preferredCallName?: string;
}

function isUuid(value: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value);
}

async function fetchStoryChatContext(
  supabase: ReturnType<typeof createSupabaseClient>,
  chatId: string | undefined,
): Promise<StoryChatContext> {
  if (!chatId) return { history: [] };
  const { data: chat, error } = await supabase
    .from("story_chats")
    .select("messages, preferred_call_name")
    .eq("id", chatId)
    .single();
  if (error || !chat) return { history: [] };
  return {
    history: Array.isArray(chat.messages) ? (chat.messages as ChatMessage[]) : [],
    preferredCallName: typeof chat.preferred_call_name === "string" ? chat.preferred_call_name : undefined,
  };
}

async function fetchProfilePreferredCallName(
  supabase: ReturnType<typeof createSupabaseClient>,
  userId: string,
): Promise<string | undefined> {
  if (!isUuid(userId)) return undefined;
  const { data, error } = await supabase
    .from("profiles")
    .select("preferred_call_name")
    .eq("id", userId)
    .maybeSingle();
  if (error || !data) return undefined;
  return typeof data.preferred_call_name === "string" ? data.preferred_call_name : undefined;
}

async function persistProfilePreferredCallName(
  supabase: ReturnType<typeof createSupabaseClient>,
  userId: string,
  preferredCallName: string,
): Promise<void> {
  if (!isUuid(userId)) return;
  const { error } = await supabase
    .from("profiles")
    .update({ preferred_call_name: preferredCallName })
    .eq("id", userId);
  if (error) {
    console.error("Failed to persist profile preferred call name:", error);
  }
}

function buildSystemPrompt(
  mode: ChatMode,
  language: string,
  history: ChatMessage[],
  message: string,
  initialContext: { title: string; storyContent: string; moral?: string } | undefined,
  user_name: string | undefined,
): string {
  const messagesWithCurrent: ChatMessage[] = [
    ...history,
    { role: "user", content: message },
  ];
  const philosophicalUserState = (mode === "philosophical")
    ? analyzePhilosophicalUserState(messagesWithCurrent)
    : undefined;
  const touristGuideIntent = (mode === "tourist_guide")
    ? analyzeUserIntentForTouristGuide(messagesWithCurrent)
    : undefined;
  let prompt = getChatSystemPrompt(
    mode,
    language,
    initialContext,
    user_name,
    philosophicalUserState,
    touristGuideIntent,
  );
  if (hasHarmfulContent(message.trim())) {
    prompt += getSafetyContext(mode);
  }
  return prompt;
}

async function saveChat(
  supabase: ReturnType<typeof createSupabaseClient>,
  chatId: string | undefined,
  userId: string,
  storyId: string | undefined,
  history: ChatMessage[],
  preferredCallNameToPersist?: string,
): Promise<string | undefined> {
  if (chatId) {
    const updatePayload: Record<string, unknown> = {
      messages: history,
      updated_at: new Date().toISOString(),
    };
    if (preferredCallNameToPersist !== undefined) {
      updatePayload.preferred_call_name = preferredCallNameToPersist;
    }
    const { error } = await supabase
      .from("story_chats")
      .update(updatePayload)
      .eq("id", chatId);
    if (error) console.error("Failed to update chat:", error);
    return chatId;
  }
  const insertPayload: Record<string, unknown> = {
    user_id: userId,
    story_id: storyId ?? null,
    messages: history,
  };
  if (preferredCallNameToPersist !== undefined) {
    insertPayload.preferred_call_name = preferredCallNameToPersist;
  }
  const { data: newChat, error } = await supabase
    .from("story_chats")
    .insert(insertPayload)
    .select("id")
    .single();
  if (error) {
    console.error("Failed to create chat:", error);
    return undefined;
  }
  return newChat?.id;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return handleOptions();

  try {
    const body: ChatRequest = await req.json();
    const {
      chat_id,
      story_id,
      message,
      mode,
      language,
      user_id,
      title,
      story_content,
      moral,
      user_name,
    } = body;

    if (!message || !mode) {
      return errorResponse("message and mode are required", 400);
    }

    const supabase = createSupabaseClient();
    const userId = user_id ?? "anonymous";
    const chatContext = await fetchStoryChatContext(supabase, chat_id);
    const history = chatContext.history;
    const profilePreferredCallName = userId !== "anonymous"
      ? await fetchProfilePreferredCallName(supabase, userId)
      : undefined;
    const explicitPreferredCallName = extractPreferredCallNameFromText(message);
    const fallbackExtractedName = extractFallbackCallName(user_name);
    const effectiveCallName = resolveEffectiveCallName({
      explicitPreferredCallName,
      chatPreferredCallName: chatContext.preferredCallName,
      profilePreferredCallName,
      fallbackExtractedName,
    });

    if (explicitPreferredCallName && userId !== "anonymous") {
      await persistProfilePreferredCallName(supabase, userId, explicitPreferredCallName);
    }

    const initialContext = title && story_content
      ? { title, storyContent: story_content, moral }
      : undefined;
    const normalizedLanguage = (() => {
      const raw = (language ?? "English").trim();
      if (!raw) return "English";
      const lower = raw.toLowerCase();
      if (lower === "en" || lower === "english") return "English";
      if (lower === "hi" || lower === "hindi") return "Hindi";
      if (lower === "ta" || lower === "tamil") return "Tamil";
      if (lower === "te" || lower === "telugu") return "Telugu";
      if (lower === "bn" || lower === "bengali") return "Bengali";
      if (lower === "mr" || lower === "marathi") return "Marathi";
      if (lower === "gu" || lower === "gujarati") return "Gujarati";
      if (lower === "kn" || lower === "kannada") return "Kannada";
      if (lower === "ml" || lower === "malayalam") return "Malayalam";
      if (lower === "pa" || lower === "punjabi") return "Punjabi";
      if (lower === "or" || lower === "odia" || lower === "oriya") return "Odia";
      if (lower === "ur" || lower === "urdu") return "Urdu";
      if (lower === "sa" || lower === "sanskrit") return "Sanskrit";
      if (lower === "as" || lower === "assamese") return "Assamese";
      return raw;
    })();
    const systemPrompt = buildSystemPrompt(
      mode,
      normalizedLanguage,
      history,
      message,
      initialContext,
      effectiveCallName,
    );

    const openRouterHistory: OpenRouterMessage[] = history.map((msg) => ({
      role: msg.role === "assistant" ? "assistant" : "user",
      content: msg.content,
    }));

    const rawResponseText = await retryWithBackoff(() =>
      chatWithHistory(openRouterHistory, message, systemPrompt, {
        temperature: 0.8,
        max_tokens: 2048,
        model: CHAT_MODEL,
      })
    );

    const { cleanResponse: responseText, suggestions: llmSuggestions } =
      extractSuggestionsFromLlmResponse(rawResponseText);

    const updatedHistory: ChatMessage[] = [
      ...history,
      { role: "user", content: message },
      { role: "assistant", content: responseText },
    ];

    const finalChatId = await saveChat(
      supabase,
      chat_id,
      userId,
      story_id,
      updatedHistory,
      explicitPreferredCallName,
    );
    const suggestions =
      llmSuggestions.length >= 1
        ? padSuggestions(llmSuggestions, 4)
        : generateDynamicSuggestions(updatedHistory, mode, responseText);

    return jsonResponse({
      response: responseText,
      chat_id: finalChatId ?? chat_id,
      suggestions,
    });
  } catch (error) {
    console.error("Error in chat-service:", error);
    const errMessage = error instanceof Error ? error.message : "Unknown error";
    if (errMessage.includes("429") || errMessage.toLowerCase().includes("rate")) {
      return errorResponse("Chat servers are busy. Please try again in a moment.", 503);
    }
    return errorResponse(`Chat error: ${errMessage}`, 500);
  }
});
