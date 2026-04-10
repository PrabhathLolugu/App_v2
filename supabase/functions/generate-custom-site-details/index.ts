import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { generateText } from "../_shared/openrouter.ts";
import { retryWithBackoff } from "../_shared/retry.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";

interface GenerateCustomSiteDetailsRequest {
  templeName: string;
  locationText: string;
  latitude?: number;
  longitude?: number;
  userContext?: string;
  language?: string;
  userId?: string;
}

interface GeneratedPayload {
  sacredLocationDraft: {
    name: string;
    latitude: number;
    longitude: number;
    intent: string[];
    type: string;
    region: string;
    tradition: string;
    description: string;
    image: string;
  };
  siteDetailsDraft: Record<string, unknown>;
  chatPrimer: {
    title: string;
    siteSummary: string;
    keyRituals: string[];
  };
}

interface HinduValidationResult {
  isAllowed: boolean;
  confidence: number;
  reason: string;
}

const SYSTEM_PROMPT = `You are a specialist in Indian sacred geography, temple history, and pilgrimage guidance.

You must output ONLY valid JSON with the exact schema requested by the user prompt.
No markdown fences. No extra prose.

Rules:
- Keep content spiritually respectful, practical, and historically grounded.
- If the location is uncertain, state uncertainty inside text fields, but still provide useful guidance.
- Do not include modern entertainment recommendations.
- For unknown image, set image to empty string.
- intent must always be ["Other"].
- siteDetailsDraft must include rich sections similar to a complete sacred-site detail page.`;

const HINDU_VALIDATOR_SYSTEM_PROMPT = `You are a strict policy validator for sacred-site submissions in a Sanatan-only app.

Return ONLY valid JSON:
{
  "isAllowed": boolean,
  "confidence": number,
  "reason": "string"
}

Validation Rules:
1. Allow only if the submission is a Sanatan sacred site (Temple, Tirtha, Dham, Peeth, Jyotirlinga, Math, Ashram, Kund, Ghat, etc.).
2. Recognize famous Sanatan sites by name (e.g., "Tirupati Balaji", "Kedarnath", "Somnath", "Sabarimala") even if the suffix "Temple" or "Mandir" is missing.
3. Reject if the site belongs to any other religion (Christianity, Islam, Sikhism, Buddhism, Jainism, etc.).
4. Reject secular places (parks, malls, stadiums), commercial spots, or ambiguous locations.
5. If the name is "Tirupati Balaji", it is a famous Hindu site and MUST be allowed.
6. Confidence should be from 0 to 1.`;

function parseModelJson(raw: string): GeneratedPayload {
  const trimmed = raw.trim();
  const fencedMatch = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const jsonCandidate = fencedMatch ? fencedMatch[1].trim() : trimmed;
  const firstBrace = jsonCandidate.indexOf("{");
  const lastBrace = jsonCandidate.lastIndexOf("}");
  const isolated = firstBrace >= 0 && lastBrace > firstBrace
    ? jsonCandidate.slice(firstBrace, lastBrace + 1)
    : jsonCandidate;

  const parsed = JSON.parse(isolated) as GeneratedPayload;
  if (!parsed.sacredLocationDraft || !parsed.siteDetailsDraft || !parsed.chatPrimer) {
    throw new Error("Model returned incomplete JSON payload");
  }

  parsed.sacredLocationDraft.intent = ["Other"];
  parsed.sacredLocationDraft.image = parsed.sacredLocationDraft.image ?? "";
  return parsed;
}

function parseValidationJson(raw: string): HinduValidationResult {
  const trimmed = raw.trim();
  const fencedMatch = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const jsonCandidate = fencedMatch ? fencedMatch[1].trim() : trimmed;
  const firstBrace = jsonCandidate.indexOf("{");
  const lastBrace = jsonCandidate.lastIndexOf("}");
  const isolated = firstBrace >= 0 && lastBrace > firstBrace
    ? jsonCandidate.slice(firstBrace, lastBrace + 1)
    : jsonCandidate;
  const parsed = JSON.parse(isolated) as HinduValidationResult;
  return {
    isAllowed: parsed.isAllowed === true,
    confidence: typeof parsed.confidence === "number" ? parsed.confidence : 0,
    reason: parsed.reason?.toString().trim() || "Validation did not provide a reason.",
  };
}

function coerceLatLng(value: unknown, fallback: number): number {
  if (typeof value === "number" && Number.isFinite(value)) {
    return value;
  }
  if (typeof value === "string") {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) {
      return parsed;
    }
  }
  return fallback;
}

function basicHinduValidation(input: string): HinduValidationResult {
  const lower = input.toLowerCase();

  // Strong blacklist for non-Sanatan religious sites
  const forbidden = [
    "church", "cathedral", "chapel", "basilica",
    "mosque", "masjid", "idgah", "dargah", "majzar",
    "synagogue",
    "gurdwara", "gurudwara",
    "monastery", "stupa", "pagoda", // Generally Buddhist unless specified Sanatan math
    "bahai", "fire temple", "agiyari",
  ];

  if (forbidden.some((token) => lower.includes(token))) {
    return {
      isAllowed: false,
      confidence: 1.0,
      reason: "This site appears to belong to another religious tradition. Only Sanatan sacred sites are supported.",
    };
  }

  // We no longer require explicit keywords like 'temple' here.
  // We let the LLM decide for ambiguous names to improve UX.
  // But we still reject obviously secular keywords if possible.
  const secular = ["mall", "multiplex", "stadium", "airport", "railway station", "bus stand"];
  if (secular.some((token) => lower.includes(token))) {
    return {
      isAllowed: false,
      confidence: 0.9,
      reason: "This appears to be a secular or commercial location.",
    };
  }

  return { isAllowed: true, confidence: 0.5, reason: "Passed basic filtering. Proceeding to AI verification." };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const body = (await req.json()) as GenerateCustomSiteDetailsRequest;
    const {
      templeName,
      locationText,
      latitude,
      longitude,
      userContext,
      language = "English",
      userId,
    } = body;

    if (!templeName || !locationText) {
      return errorResponse("templeName and locationText are required", 400);
    }

    if (!userId) {
      return errorResponse("userId is required for moderated submission tracking", 400);
    }

    const latHint = typeof latitude === "number" ? latitude : null;
    const lonHint = typeof longitude === "number" ? longitude : null;

    const baseValidation = basicHinduValidation(
      `${templeName} ${locationText} ${userContext ?? ""}`,
    );
    if (!baseValidation.isAllowed) {
      return errorResponse(
        `Only Sanatan sacred sites are allowed. ${baseValidation.reason}`,
        400,
        { type: "POLICY_VIOLATION", reason: baseValidation.reason },
      );
    }

    const validatorPrompt = `Submission to validate:
- templeName: ${templeName}
- locationText: ${locationText}
- userContext: ${userContext?.trim() || "none"}

Decide if this belongs to Sanatan sacred geography only.`;
    let validation = baseValidation;
    try {
      const validationRaw = await retryWithBackoff(async () => {
        return await generateText(validatorPrompt, HINDU_VALIDATOR_SYSTEM_PROMPT, {
          temperature: 0.0,
          max_tokens: 300,
        });
      });
      validation = parseValidationJson(validationRaw);
    } catch (_) {
      // Keep base validation when model output is malformed.
    }
    if (!validation.isAllowed || validation.confidence < 0.6) {
      return errorResponse(
        `Only Sanatan sacred sites are allowed. ${validation.reason}`,
        400,
        { type: "POLICY_VIOLATION", reason: validation.reason },
      );
    }

    const userPrompt = `Create complete sacred-site detail JSON for a user-submitted temple.

Input:
- templeName: ${templeName}
- locationText: ${locationText}
- latitudeHint: ${latHint ?? "unknown"}
- longitudeHint: ${lonHint ?? "unknown"}
- userContext: ${userContext?.trim() || "none"}
- outputLanguage: ${language}

Instructions:
- IMPORTANT: The user's latitudeHint and longitudeHint might be completely wrong. DO NOT copy them blindly!
- You MUST find and return the exact, real-world verified GPS coordinates (latitude and longitude) for the site.
- Only use the hints to disambiguate if there are multiple temples with the same name.
Output EXACT JSON schema:
{
  "sacredLocationDraft": {
    "name": "string",
    "latitude": number,
    "longitude": number,
    "intent": ["Other"],
    "type": "string",
    "region": "string",
    "tradition": "string",
    "description": "string",
    "image": "string"
  },
  "siteDetailsDraft": {
    "name": "string",
    "location": "string",
    "heroImage": "string",
    "heroImageLabel": "string",
    "about": "string",
    "history": "string",
    "visitingHours": "string",
    "bestTimeToVisit": "string",
    "howToReach": "string",
    "localTransport": "string",
    "stayOptions": "string",
    "festivals": ["string", "string"],
    "nearbyPlaces": ["string", "string"],
    "rituals": ["string", "string"],
    "travelTips": ["string", "string"]
  },
  "chatPrimer": {
    "title": "string",
    "siteSummary": "string",
    "keyRituals": ["string", "string"]
  }
}

Constraints:
- Keep strings concise but informative.
- If unknown facts, provide cautious wording.
- Keep all content about spirituality/pilgrimage only.
- Output only valid JSON.`;

    const raw = await retryWithBackoff(async () => {
      return await generateText(userPrompt, SYSTEM_PROMPT, {
        temperature: 0.4,
        max_tokens: 3500,
      });
    });

    const generated = parseModelJson(raw);
    generated.sacredLocationDraft.latitude = coerceLatLng(
      generated.sacredLocationDraft.latitude,
      coerceLatLng(latitude, 20.5937),
    );
    generated.sacredLocationDraft.longitude = coerceLatLng(
      generated.sacredLocationDraft.longitude,
      coerceLatLng(longitude, 78.9629),
    );
    generated.sacredLocationDraft.intent = ["Other"];

    const supabase = createSupabaseClient();
    const { data: latestLocation } = await supabase
      .from("sacred_locations")
      .select("id")
      .order("id", { ascending: false })
      .limit(1)
      .maybeSingle();
    const nextLocationId = ((latestLocation?.id as number | undefined) ?? 0) + 1;

    const { data: insertedLocation, error: locationError } = await supabase
      .from("sacred_locations")
      .insert({
        id: nextLocationId,
        name: generated.sacredLocationDraft.name || templeName,
        latitude: generated.sacredLocationDraft.latitude,
        longitude: generated.sacredLocationDraft.longitude,
        intent: ["Other"],
        type: generated.sacredLocationDraft.type || "Other",
        region: generated.sacredLocationDraft.region || "Bharat",
        tradition: generated.sacredLocationDraft.tradition || "Sanatan",
        ref: locationText,
        image: generated.sacredLocationDraft.image || "",
        semanticLabel:
          `Sanatan sacred site: ${generated.sacredLocationDraft.name || templeName} in ${locationText}`,
        description: generated.sacredLocationDraft.description || "",
      })
      .select("id")
      .single();

    if (locationError || !insertedLocation?.id) {
      console.error("Failed to insert sacred_locations:", locationError);
      return errorResponse(
        `Failed to publish sacred location: ${locationError?.message ?? "unknown error"}`,
        500,
      );
    }
    const publishedLocationId = insertedLocation.id as number;

    const { error: detailError } = await supabase
      .from("site_details")
      .upsert({
        id: publishedLocationId,
        name: (generated.siteDetailsDraft["name"] ?? generated.sacredLocationDraft.name)
          .toString(),
        location: (generated.siteDetailsDraft["location"] ?? locationText).toString(),
        heroImage: (generated.siteDetailsDraft["heroImage"] ??
          generated.sacredLocationDraft.image ??
          "")
          .toString(),
        heroImageLabel: (generated.siteDetailsDraft["heroImageLabel"] ??
          generated.sacredLocationDraft.name)
          .toString(),
        about: (generated.siteDetailsDraft["about"] ??
          generated.sacredLocationDraft.description ??
          "")
          .toString(),
        history: (generated.siteDetailsDraft["history"] ?? "").toString(),
        visitingHours: (generated.siteDetailsDraft["visitingHours"] ?? "").toString(),
        best_time_to_visit: (generated.siteDetailsDraft["bestTimeToVisit"] ?? "").toString(),
        festivals: Array.isArray(generated.siteDetailsDraft["festivals"])
          ? (generated.siteDetailsDraft["festivals"] as unknown[]).join("\n")
          : (generated.siteDetailsDraft["festivals"] ?? "").toString(),
      });

    if (detailError) {
      console.error("Failed to insert site_details:", detailError);
      await supabase.from("sacred_locations").delete().eq("id", publishedLocationId);
      return errorResponse(
        `Failed to publish site details: ${detailError.message}`,
        500,
      );
    }

    generated.siteDetailsDraft["id"] = publishedLocationId;

    const { data: submission, error: insertError } = await supabase
      .from("custom_site_submissions")
      .insert({
        created_by: userId,
        status: "approved",
        temple_name: templeName,
        input_location_text: locationText,
        latitude: generated.sacredLocationDraft.latitude,
        longitude: generated.sacredLocationDraft.longitude,
        user_notes: userContext || null,
        generated_site_details_json: generated.siteDetailsDraft,
        generated_sacred_location_json: generated.sacredLocationDraft,
        chat_primer_json: generated.chatPrimer,
        published_location_id: publishedLocationId,
      })
      .select("id, status, created_at")
      .single();

    if (insertError) {
      console.error("Failed to insert custom_site_submissions:", insertError);
      // Publishing already succeeded; do not fail user-visible flow.
    }

    return jsonResponse({
      submissionId: submission?.id ?? "",
      submissionStatus: submission?.status ?? "approved",
      submissionCreatedAt: submission?.created_at ?? new Date().toISOString(),
      publishedLocationId,
      ...generated,
    });
  } catch (error) {
    console.error("Error in generate-custom-site-details:", error);
    const message = error instanceof Error ? error.message : "Unknown error";
    if (message.toLowerCase().includes("rate") || message.includes("429")) {
      return errorResponse(
        "Generation servers are busy. Please try again in a moment.",
        503,
      );
    }
    return errorResponse(`Failed to generate custom site details: ${message}`, 500);
  }
});
