import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { generateText, type GenerationConfig } from "../_shared/openrouter.ts";
import { retryWithBackoff } from "../_shared/retry.ts";

// Use specific model for translation
const TRANSLATION_MODEL = "google/gemini-2.5-flash-lite";

/**
 * Translation Edge Function
 *
 * Translates stories to different Indian languages using OpenRouter
 */

interface TranslationRequest {
  title: string;
  story: string;
  moral: string;
  trivia?: string;
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

interface TranslationResponse {
  title: string;
  story: string;
  moral: string;
  trivia?: string;
}

const TARGET_LANG_ALIASES: Record<string, string> = {
  en: "en",
  english: "en",
  "en-in": "en",
  hi: "hi",
  hindi: "hi",
  "hi-in": "hi",
  te: "te",
  telugu: "te",
  "te-in": "te",
  ta: "ta",
  tamil: "ta",
  "ta-in": "ta",
  bn: "bn",
  bengali: "bn",
  "bn-in": "bn",
  mr: "mr",
  marathi: "mr",
  "mr-in": "mr",
  gu: "gu",
  gujarati: "gu",
  "gu-in": "gu",
  kn: "kn",
  kannada: "kn",
  "kn-in": "kn",
  ml: "ml",
  malayalam: "ml",
  "ml-in": "ml",
  pa: "pa",
  punjabi: "pa",
  "pa-in": "pa",
  or: "or",
  odia: "or",
  oriya: "or",
  "or-in": "or",
  ur: "ur",
  urdu: "ur",
  "ur-in": "ur",
  "ur-pk": "ur",
  sa: "sa",
  sanskrit: "sa",
  as: "as",
  assamese: "as",
  "as-in": "as",
};

const LANGUAGE_MAP: Record<string, string> = {
  en: "English",
  hi: "Hindi",
  te: "Telugu",
  ta: "Tamil",
  bn: "Bengali",
  mr: "Marathi",
  gu: "Gujarati",
  kn: "Kannada",
  ml: "Malayalam",
  pa: "Punjabi",
  or: "Odia",
  ur: "Urdu",
  sa: "Sanskrit",
  as: "Assamese",
};

function normalizeTargetLang(input: string): string | null {
  const normalized = input.trim().toLowerCase().replaceAll("_", "-");
  if (!normalized) return null;
  if (TARGET_LANG_ALIASES[normalized]) {
    return TARGET_LANG_ALIASES[normalized];
  }
  const head = normalized.split("-")[0];
  if (TARGET_LANG_ALIASES[head]) {
    return TARGET_LANG_ALIASES[head];
  }
  return null;
}

async function translateFieldFallback(
  fieldLabel: string,
  content: string,
  targetLanguage: string,
): Promise<string> {
  if (!content.trim()) return "";

  const systemPrompt =
    `You are a professional translator. Translate to ${targetLanguage}. ` +
    `Preserve meaning, proper nouns, and tone. Return only translated text.`;
  const userPrompt =
    `Translate this ${fieldLabel} into ${targetLanguage}:\n\n${content}`;

  const translated = await retryWithBackoff(async () =>
    generateText(userPrompt, systemPrompt, {
      temperature: 0.2,
      max_tokens: 4000,
      model: TRANSLATION_MODEL,
    })
  );

  return translated.trim();
}

/**
 * Parse chapters from story content based on the "-----" separator.
 * Returns array of chapter texts (preserving original content).
 */
function parseChapters(storyContent: string): string[] {
  const content = storyContent.trim();
  if (!content) return [];

  // Split by the chapter separator (-----) - the same regex as in the Dart code
  const parts = content.split(/\n\s*-----\s*\n/);
  return parts.filter(part => part.trim().length > 0);
}

/**
 * Rebuild story content from chapters while preserving the exact format.
 */
function rebuildStoryContent(chapters: string[]): string {
  if (chapters.length === 0) return "";
  
  const buffer: string[] = [];
  buffer.push(chapters[0].trim());
  
  for (let i = 1; i < chapters.length; i++) {
    buffer.push("\n\n-----\n");
    // Extract chapter header if it exists or build one
    const chapter = chapters[i].trim();
    const lines = chapter.split("\n");
    
    // Check if first line is a chapter header
    const headerMatch = lines[0].match(/^Chapter\s+(\d+)\s*$/i);
    if (headerMatch) {
      // Already has header, use as-is
      buffer.push(chapter);
    } else {
      // Add chapter header
      buffer.push(`Chapter ${i + 1}\n${chapter}`);
    }
  }
  
  return buffer.join("").trim();
}

/**
 * Translate story content while preserving chapter structure.
 * Translates each chapter separately and reconstructs the story.
 */
async function translateStoryWithStructurePreservation(
  storyContent: string,
  targetLanguage: string,
): Promise<string> {
  if (!storyContent.trim()) return "";

  // Parse chapters from the original content
  const chapters = parseChapters(storyContent);
  if (chapters.length === 0) return "";

  // Translate each chapter separately
  const translatedChapters = await Promise.all(
    chapters.map(chapter =>
      translateFieldFallback("story chapter", chapter, targetLanguage)
    )
  );

  // Rebuild the story with the exact same structure
  return rebuildStoryContent(translatedChapters);
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const body: TranslationRequest = await req.json();
    const { title, story, moral, trivia = "", target_lang } = body;
    const normalizedTargetLang = normalizeTargetLang(String(target_lang ?? ""));

    if (!title || !story || !normalizedTargetLang) {
      return errorResponse("title, story, and target_lang are required", 400);
    }

    if (!LANGUAGE_MAP[normalizedTargetLang]) {
      return errorResponse(
        "Invalid target_lang. Must be one of: en, hi, te, ta, bn, mr, gu, kn, ml, pa, or, ur, sa, as",
        400
      );
    }

    const targetLanguage = LANGUAGE_MAP[normalizedTargetLang];

    // Translate each field while preserving story structure
    const translatedTitle = await translateFieldFallback("title", title, targetLanguage);
    const translatedStory = await translateStoryWithStructurePreservation(
      story,
      targetLanguage
    );
    const translatedMoral = await translateFieldFallback("moral", moral, targetLanguage);
    const translatedTrivia = trivia
      ? await translateFieldFallback("trivia", trivia, targetLanguage)
      : "";

    // Validate response
    if (!translatedTitle?.trim() || !translatedStory?.trim()) {
      throw new Error("Invalid translation response");
    }

    return jsonResponse({
      title: translatedTitle,
      story: translatedStory,
      moral: translatedMoral || moral,
      trivia: translatedTrivia ?? trivia ?? "",
      lang: normalizedTargetLang,
    });

  } catch (error) {
    console.error("Error in translation:", error);
    const message = error instanceof Error ? error.message : "Unknown error";

    if (message.includes("429") || message.toLowerCase().includes("rate")) {
      return errorResponse(
        "Translation servers are busy. Please try again in a moment.",
        503
      );
    }

    return errorResponse(`Translation error: ${message}`, 500);
  }
});
