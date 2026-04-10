import { UniversalEdgeTTS, listVoicesUniversal } from "edge-tts-universal";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import {
    binaryResponse,
    errorResponse,
    handleOptions,
} from "../_shared/cors.ts";

/**
 * Edge TTS Edge Function
 *
 * Synthesizes speech using Microsoft Edge TTS for Indian languages.
 * Returns MP3 audio. Used for human-like read-aloud in the app.
 */

const MAX_TEXT_LENGTH = 3000;

/**
 * Preferred voices per locale (ordered). If a candidate is not available in
 * the runtime voice list, we gracefully fall back to locale-matched discovery.
 */
const PREFERRED_VOICE_CANDIDATES: Record<string, string[]> = {
  "en-IN": ["en-IN-NeerjaExpressiveNeural", "en-IN-NeerjaNeural", "en-IN-PrabhatNeural"],
  "hi-IN": ["hi-IN-SwaraNeural", "hi-IN-MadhurNeural"],
  "ta-IN": ["ta-IN-PallaviNeural", "ta-IN-ValluvarNeural"],
  "te-IN": ["te-IN-ShrutiNeural", "te-IN-MohanNeural"],
  "bn-IN": ["bn-IN-TanishaaNeural", "bn-IN-BashkarNeural"],
  "mr-IN": ["mr-IN-AarohiNeural", "mr-IN-ManoharNeural"],
  "gu-IN": ["gu-IN-DhwaniNeural", "gu-IN-NiranjanNeural"],
  "kn-IN": ["kn-IN-SapnaNeural", "kn-IN-GaganNeural"],
  "ml-IN": ["ml-IN-SobhanaNeural", "ml-IN-MidhunNeural"],
  "pa-IN": ["pa-IN-GurleenNeural", "pa-IN-VikasNeural"],
  "or-IN": ["or-IN-AyushiNeural"],
  "as-IN": ["as-IN-YashicaNeural"],
  "ur-IN": ["ur-IN-UzmaNeural", "ur-IN-SalmanNeural"],
  "ur-PK": ["ur-PK-UzmaNeural", "ur-PK-AsadNeural"],
};

const LOCALE_FALLBACK_CANDIDATES: Record<string, string[]> = {
  "ur-IN": ["ur-PK"],
  "ur-PK": ["ur-IN"],
};

const SUPPORTED_LOCALES = new Set([
  "en-IN",
  "hi-IN",
  "ta-IN",
  "te-IN",
  "bn-IN",
  "mr-IN",
  "gu-IN",
  "kn-IN",
  "ml-IN",
  "pa-IN",
  "or-IN",
  "ur-IN",
  "ur-PK",
  "as-IN",
]);

interface EdgeTTSRequest {
  text: string;
  locale?: string;
  language?: string;
}

let cachedVoices:
  | {
      ShortName?: string;
      Locale?: string;
    }[]
  | null = null;

const LANGUAGE_CODE_TO_LOCALE: Record<string, string> = {
  en: "en-IN",
  hi: "hi-IN",
  ta: "ta-IN",
  te: "te-IN",
  bn: "bn-IN",
  mr: "mr-IN",
  gu: "gu-IN",
  kn: "kn-IN",
  ml: "ml-IN",
  pa: "pa-IN",
  or: "or-IN",
  ur: "ur-IN",
  as: "as-IN",
  sa: "en-IN",
};

const LOCALE_ALIAS_TO_CANONICAL: Record<string, string> = {
  "en": "en-IN",
  "en-in": "en-IN",
  "en-us": "en-IN",
  "hi": "hi-IN",
  "hi-in": "hi-IN",
  "ta": "ta-IN",
  "ta-in": "ta-IN",
  "te": "te-IN",
  "te-in": "te-IN",
  "bn": "bn-IN",
  "bn-in": "bn-IN",
  "mr": "mr-IN",
  "mr-in": "mr-IN",
  "gu": "gu-IN",
  "gu-in": "gu-IN",
  "kn": "kn-IN",
  "kn-in": "kn-IN",
  "ml": "ml-IN",
  "ml-in": "ml-IN",
  "pa": "pa-IN",
  "pa-in": "pa-IN",
  "or": "or-IN",
  "odia": "or-IN",
  "oriya": "or-IN",
  "or-in": "or-IN",
  "ur": "ur-IN",
  "ur-in": "ur-IN",
  "ur-pk": "ur-PK",
  "as": "as-IN",
  "assamese": "as-IN",
  "as-in": "as-IN",
  "sa": "en-IN",
};

export function normalizeLocaleInput(input: string): string | null {
  const normalized = input.trim().replaceAll("_", "-").toLowerCase();
  if (!normalized) return null;

  if (LOCALE_ALIAS_TO_CANONICAL[normalized]) {
    return LOCALE_ALIAS_TO_CANONICAL[normalized];
  }

  const langPrefix = normalized.split("-")[0];
  if (LANGUAGE_CODE_TO_LOCALE[langPrefix]) {
    return LANGUAGE_CODE_TO_LOCALE[langPrefix];
  }
  return null;
}

async function resolveVoiceShortName(locale: string): Promise<string | null> {
  const normalized = locale.trim();

  if (!cachedVoices) {
    try {
      cachedVoices = await listVoicesUniversal();
    } catch (error) {
      console.error("[edge-tts] Failed to list voices:", error);
      cachedVoices = [];
    }
  }

  const voices = cachedVoices ?? [];

  const hasVoice = (shortName?: string) =>
    !!shortName &&
    voices.some((v) => v.ShortName && v.ShortName === shortName);

  const preferred = PREFERRED_VOICE_CANDIDATES[normalized] ?? [];
  for (const candidate of preferred) {
    if (hasVoice(candidate)) {
      return candidate;
    }
  }

  const localeMatches = voices
    .filter((v) => v.Locale === normalized && v.ShortName)
    .map((v) => v.ShortName as string);

  const expressive = localeMatches.find((name) => name.includes("Expressive"));
  if (expressive) {
    return expressive;
  }

  const neural = localeMatches.find((name) => name.endsWith("Neural"));
  if (neural) {
    return neural;
  }

  const localeFallbacks = LOCALE_FALLBACK_CANDIDATES[normalized] ?? [];
  for (const fallbackLocale of localeFallbacks) {
    const fallbackPreferred = PREFERRED_VOICE_CANDIDATES[fallbackLocale] ?? [];
    for (const candidate of fallbackPreferred) {
      if (hasVoice(candidate)) {
        return candidate;
      }
    }

    const fallbackLocaleMatch = voices.find(
      (v) => v.Locale === fallbackLocale && v.ShortName,
    );
    if (fallbackLocaleMatch?.ShortName) {
      return fallbackLocaleMatch.ShortName;
    }
  }

  return null;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  if (req.method !== "POST") {
    return errorResponse("Method not allowed", 405);
  }

  try {
    const body = (await req.json()) as EdgeTTSRequest;
    const { text, locale, language } = body;

    if (!text || typeof text !== "string") {
      return errorResponse("text is required and must be a string", 400);
    }
    const localeSource = locale ?? language;
    if (!localeSource || typeof localeSource !== "string") {
      return errorResponse("locale (or language) is required and must be a string", 400);
    }

    const trimmed = text.trim();
    if (trimmed.length === 0) {
      return errorResponse("text cannot be empty", 400);
    }
    if (trimmed.length > MAX_TEXT_LENGTH) {
      return errorResponse(
        `text must be at most ${MAX_TEXT_LENGTH} characters`,
        400
      );
    }

    const normalizedLocale = normalizeLocaleInput(localeSource);
    if (!normalizedLocale) {
      return errorResponse(
        "Unsupported locale value. Provide a known language/locale code.",
        400,
        {
          provided: localeSource,
          reason: "locale_normalization_failed",
          supportedLocales: [...SUPPORTED_LOCALES],
        },
      );
    }
    if (!SUPPORTED_LOCALES.has(normalizedLocale)) {
      return errorResponse(
        `Unsupported locale: ${normalizedLocale}. Supported: ${[...SUPPORTED_LOCALES].join(", ")}`,
        400,
        {
          provided: localeSource,
          normalizedLocale,
          reason: "unsupported_locale",
          supportedLocales: [...SUPPORTED_LOCALES],
        },
      );
    }

    const voice = await resolveVoiceShortName(normalizedLocale);
    if (!voice) {
      return errorResponse(
        `No voice configured for locale: ${normalizedLocale}`,
        400,
        { normalizedLocale, reason: "voice_not_found" },
      );
    }

    let result: { audio: { arrayBuffer(): Promise<ArrayBuffer> } };
    try {
      const tts = new UniversalEdgeTTS(trimmed, voice);
      result = await tts.synthesize();
    } catch (primaryErr) {
      console.error(
        `[edge-tts] Synthesis failed for locale ${normalizedLocale} with voice ${voice}:`,
        primaryErr,
      );
      throw primaryErr;
    }

    const audioBuffer = await result.audio.arrayBuffer();
    return binaryResponse(audioBuffer, "audio/mpeg", 200);
  } catch (err) {
    console.error("[edge-tts] Synthesis error:", err);
    const message = err instanceof Error ? err.message : "Unknown error";
    if (message.toLowerCase().includes("voice") || message.toLowerCase().includes("not found")) {
      return errorResponse(
        "Voice not available for this locale. Try another language or use device TTS.",
        400,
        { reason: "voice_resolution_or_generation_failed" },
      );
    }
    return errorResponse(`TTS synthesis failed: ${message}`, 500);
  }
});
