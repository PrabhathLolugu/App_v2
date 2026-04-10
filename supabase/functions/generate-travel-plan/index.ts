import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

/**
 * Generate Travel Plan Edge Function
 *
 * Produces a detailed spiritual pilgrimage plan (how to reach, days per place,
 * nearby temples/sacred sites, what to do) using OpenRouter. Content is
 * spirituality-only; no malls, movies, or western tourism.
 *
 * Self-contained so it can be deployed from Supabase Dashboard (no _shared imports).
 */

// ----- CORS (inlined) -----
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function handleOptions(): Response {
  return new Response(null, { status: 204, headers: corsHeaders });
}

function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function errorResponse(message: string, status = 500): Response {
  return jsonResponse({ error: message }, status);
}

// ----- OpenRouter (inlined) -----
const OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions";
const OPENROUTER_MODEL = "gwen/gwen-2.5-72b-instruct";

async function generateText(
  prompt: string,
  systemPrompt: string,
  options: { temperature?: number; max_tokens?: number } = {}
): Promise<string> {
  let apiKey = Deno.env.get("OPENROUTER_API_KEY") ?? "";
  apiKey = apiKey.trim();
  if (apiKey.includes("=")) {
    apiKey = apiKey.split("=").pop()?.trim() ?? apiKey;
  }
  apiKey = apiKey.replace(/^["']|["']$/g, "");
  if (!apiKey) {
    throw new Error("OPENROUTER_API_KEY environment variable is required");
  }
  if (!apiKey.startsWith("sk-or-v1-")) {
    throw new Error(
      "OPENROUTER_API_KEY should start with sk-or-v1-. Check Project Settings > Edge Functions > Secrets and set the value to only your key from openrouter.ai/keys (no NAME= prefix, no quotes)."
    );
  }

  const response = await fetch(OPENROUTER_API_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "HTTP-Referer": "https://myitihas.app",
      "X-Title": "MyItihas",
    },
    body: JSON.stringify({
      model: OPENROUTER_MODEL,
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: prompt },
      ],
      temperature: options.temperature ?? 0.5,
      max_tokens: options.max_tokens ?? 6000,
    }),
  });

  if (!response.ok) {
    const err = await response.text();
    if (response.status === 401) {
      throw new Error(
        "OpenRouter returned 401 (invalid or missing API key). In Supabase: Project Settings > Edge Functions > Secrets, set OPENROUTER_API_KEY to only your key from openrouter.ai/keys (no OPENROUTER_API_KEY= prefix, no quotes). Then redeploy this function."
      );
    }
    throw new Error(`OpenRouter API error: ${response.status} - ${err}`);
  }

  const data = await response.json();
  const content = data?.choices?.[0]?.message?.content;
  return typeof content === "string" ? content : "";
}

// ----- Supabase client (inlined) -----
function createSupabaseClient() {
  const url = Deno.env.get("SUPABASE_URL");
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !key) {
    throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  }
  return createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

// ----- Request type & system prompt -----
interface GenerateTravelPlanRequest {
  fromLocation: string;
  startDate: string;
  endDate: string;
  destinationId: number;
  destinationName: string;
  userId?: string;
  nearbyTempleNames?: string[];
  customDestinationContext?: string;
}

const SYSTEM_PROMPT = `You are an expert on Indian sacred sites and pilgrimage (tirtha yatra). Your task is to write a detailed, practical spiritual travel plan.

RULES:
- Focus ONLY on spiritual and pilgrimage-related content: temples, darshan, rituals, festivals, meditation, sacred geography, nearby holy places, how to reach, suggested days at each place, what a pilgrim can do (puja, parikrama, dhyana, etc.).
- Do NOT include: malls, multiplexes, movies, western tourism, generic sightseeing, nightlife, or commercial entertainment.
- Write in a warm, reverent tone suitable for someone planning a pilgrimage.
- Be specific: transport options (trains/buses from the given origin), approximate travel time, where to stay (ashrams, dharamshalas, simple lodges near the temple), best times to visit, festivals to consider.
- Suggest a day-wise or phase-wise itinerary that fits the given date range.
- Mention nearby sacred sites and temples the visitor can include.
- Use clear sections (e.g. "Getting there", "Suggested itinerary", "Nearby sacred sites", "What to do at the destination", "Practical tips").`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const body = (await req.json()) as GenerateTravelPlanRequest;
    const {
      fromLocation,
      startDate,
      endDate,
      destinationId,
      destinationName,
      nearbyTempleNames,
      customDestinationContext,
    } = body;

    if (!fromLocation || !startDate || !endDate || !destinationName) {
      return errorResponse(
        "fromLocation, startDate, endDate, and destinationName are required",
        400
      );
    }

    let destinationContext = `Destination: ${destinationName}.`;
    if (customDestinationContext && customDestinationContext.trim().length > 0) {
      destinationContext = `Destination: ${destinationName}. ${customDestinationContext.trim()}`;
    } else {
      try {
        const supabase = createSupabaseClient();
        const { data: loc } = await supabase
          .from("sacred_locations")
          .select("name, region, description, type, tradition")
          .eq("id", destinationId)
          .maybeSingle();

        if (loc) {
          destinationContext = [
            `Destination: ${loc.name}.`,
            loc.region ? `Region: ${loc.region}.` : "",
            loc.description ? `About: ${loc.description}.` : "",
            loc.type ? `Type: ${loc.type}.` : "",
            loc.tradition ? `Tradition: ${loc.tradition}.` : "",
          ]
            .filter(Boolean)
            .join(" ");
        }
      } catch (e) {
        console.warn("Could not fetch sacred_locations:", e);
      }
    }

    const nearbySection =
      nearbyTempleNames && nearbyTempleNames.length > 0
        ? `\n- Emphasize these nearby sacred sites as special attractions (include brief descriptions in "Nearby sacred sites"): ${nearbyTempleNames.join(", ")}.`
        : "";

    const userPrompt = `Create a detailed spiritual pilgrimage plan with the following details:

- Travelling FROM: ${fromLocation}
- Start date: ${startDate}
- End date: ${endDate}
- ${destinationContext}${nearbySection}

Write a long, detailed plan (multiple paragraphs) covering: how to reach from ${fromLocation}, suggested number of days at the main destination and any nearby sacred sites, list of nearby temples or sacred places to visit, what the visitor can do there (darshan, rituals, meditation, festivals), and practical tips. Use clear section headings. Keep everything focused on spirituality and pilgrimage only.`;

    const plan = await generateText(userPrompt, SYSTEM_PROMPT, {
      temperature: 0.5,
      max_tokens: 6000,
    });

    return jsonResponse({ plan: plan || "Unable to generate plan." });
  } catch (error) {
    console.error("Error in generate-travel-plan:", error);
    const message =
      error instanceof Error ? error.message : "Unknown error";
    if (message.includes("401") || message.includes("invalid or missing API key")) {
      return errorResponse(message, 503);
    }
    if (message.includes("OPENROUTER") || message.includes("API")) {
      return errorResponse("Plan generation is temporarily unavailable.", 503);
    }
    return errorResponse(`Failed to generate plan: ${message}`, 500);
  }
});
