/**
 * Shared OpenRouter AI Client Configuration
 * Uses OpenRouter API for accessing Gemini models
 */

const OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions";

// Lazy-load and normalize API key (handles VALUE or "NAME=VALUE" or quoted value).
// Read at request time so secrets are available in all runtimes.
function getOpenRouterApiKey(): string {
  let key = Deno.env.get("OPENROUTER_API_KEY") ?? "";
  key = key.trim();
  if (key.includes("=")) {
    key = key.split("=").pop()?.trim() ?? key;
  }
  key = key.replace(/^["']|["']$/g, "");
  if (!key) {
    throw new Error("OPENROUTER_API_KEY environment variable is required");
  }
  return key;
}

// Model mappings - Gemini models via OpenRouter
export const MODELS = {
  TEXT: "gwen/qwen-2.5-72b-instruct",
  IMAGE: "google/gemini-2.5-flash-image",
} as const;

export interface GenerationConfig {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface OpenRouterResponse {
  id: string;
  choices: Array<{
    message: {
      role: string;
      content: string;
    };
    finish_reason: string;
  }>;
  usage?: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

export interface GenerationConfig {
  temperature?: number;
  max_tokens?: number;
  top_p?: number;
  response_format?: { type: "json_object" };
  model?: string; // Allow custom model override
}

/**
 * Call OpenRouter API for chat completions
 */
export async function chatCompletion(
  messages: ChatMessage[],
  config: GenerationConfig = {},
  model?: string
): Promise<OpenRouterResponse> {
  const finalModel = model || config.model || MODELS.TEXT;
  const apiKey = getOpenRouterApiKey();
  const response = await fetch(OPENROUTER_API_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "HTTP-Referer": "https://myitihas.app",
      "X-Title": "MyItihas",
    },
    body: JSON.stringify({
      model: finalModel,
      messages,
      temperature: config.temperature ?? 0.7,
      max_tokens: config.max_tokens ?? 4096,
      top_p: config.top_p ?? 0.95,
      ...(config.response_format && { response_format: config.response_format }),
    }),
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(
      `OpenRouter API error: ${response.status} ${response.statusText} - ${errorBody}`
    );
  }

  return await response.json();
}

/**
 * Simple text generation with a single prompt
 */
export async function generateText(
  prompt: string,
  systemPrompt?: string,
  config: GenerationConfig = {}
): Promise<string> {
  const messages: ChatMessage[] = [];

  if (systemPrompt) {
    messages.push({ role: "system", content: systemPrompt });
  }

  messages.push({ role: "user", content: prompt });

  const response = await chatCompletion(messages, config);
  return response.choices[0]?.message?.content || "";
}

/**
 * Generate JSON response with structured output
 */
export async function generateJSON<T>(
  prompt: string,
  systemPrompt?: string,
  config: GenerationConfig = {}
): Promise<T> {
  const response = await generateText(prompt, systemPrompt, {
    ...config,
    response_format: { type: "json_object" },
  });

  // Try strict JSON parsing first
  const raw = response?.trim() ?? "";

  const tryParse = (text: string): T => JSON.parse(text) as T;

  try {
    return tryParse(raw);
  } catch {
    // Fallback 1: strip common Markdown fences like ```json ... ```
    const fenceStripped = raw
      .replace(/^```(?:json)?\s*/i, "")
      .replace(/```$/i, "")
      .trim();

    try {
      if (fenceStripped) {
        return tryParse(fenceStripped);
      }
    } catch {
      // ignore and try next strategy
    }

    // Fallback 2: extract the first JSON object substring
    const firstBrace = raw.indexOf("{");
    const lastBrace = raw.lastIndexOf("}");
    if (firstBrace !== -1 && lastBrace !== -1 && lastBrace > firstBrace) {
      const candidate = raw.slice(firstBrace, lastBrace + 1);
      try {
        return tryParse(candidate);
      } catch {
        // ignore, will throw generic error below
      }
    }

    // If all strategies fail, surface the raw model output for debugging
    throw new Error(`Failed to parse JSON response: ${raw}`);
  }
}

/**
 * Chat with history support
 */
export async function chatWithHistory(
  history: ChatMessage[],
  newMessage: string,
  systemPrompt?: string,
  config: GenerationConfig = {}
): Promise<string> {
  const messages: ChatMessage[] = [];

  if (systemPrompt) {
    messages.push({ role: "system", content: systemPrompt });
  }

  messages.push(...history);
  messages.push({ role: "user", content: newMessage });

  const response = await chatCompletion(messages, config);
  return response.choices[0]?.message?.content || "";
}
