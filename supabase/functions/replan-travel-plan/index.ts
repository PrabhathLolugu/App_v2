import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

/**
 * Replan Travel Plan Edge Function
 *
 * Allows users to modify existing pilgrimage plans based on feedback.
 * Supports two modes:
 * 1. FULL_REGENERATE: Regenerates the entire plan with new context
 * 2. SURGICAL_MODIFY: Analyzes changes and surgically modifies only affected sections
 *
 * Self-contained for deployment from Supabase Dashboard.
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
const OPENROUTER_MODEL = "google/gemini-2.5-flash-lite";

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
      "OPENROUTER_API_KEY should start with sk-or-v1-. Check Project Settings > Edge Functions > Secrets and set OPENROUTER_API_KEY."
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
        "OpenRouter returned 401 (invalid or missing API key)."
      );
    }
    throw new Error(`OpenRouter API error: ${response.status} - ${err}`);
  }

  const data = await response.json();
  const content = data?.choices?.[0]?.message?.content;
  return typeof content === "string" ? content : "";
}

// ----- Request type -----
interface ReplanTravelPlanRequest {
  originalPlan: string;
  userFeedback: string;
  mode: "FULL_REGENERATE" | "SURGICAL_MODIFY";
  fromLocation: string;
  startDate: string;
  endDate: string;
  destinationName: string;
  destinationContext?: string;
}

// ----- System prompts -----
const FULL_REGENERATE_SYSTEM_PROMPT = `You are an expert on Indian sacred sites and pilgrimage (tirtha yatra). Based on user feedback, generate a completely new detailed, practical spiritual travel plan.

RULES:
- Focus ONLY on spiritual and pilgrimage-related content: temples, darshan, rituals, festivals, meditation, sacred geography, nearby holy places, how to reach, suggested days at each place, what a pilgrim can do (puja, parikrama, dhyana, etc.).
- Do NOT include: malls, multiplexes, movies, western tourism, generic sightseeing, nightlife, or commercial entertainment.
- Write in a warm, reverent tone suitable for someone planning a pilgrimage.
- Be specific: transport options (trains/buses), approximate travel time, where to stay (ashrams, dharamshalas), best times to visit, festivals.
- Suggest a day-wise or phase-wise itinerary that fits the given date range.
- Mention nearby sacred sites and temples the visitor can include.
- Use clear sections (e.g. "Getting there", "Suggested itinerary", "Nearby sacred sites", "What to do at the destination", "Practical tips").`;

const SURGICAL_MODIFY_SYSTEM_PROMPT = `You are an expert pilgrimage plan consultant. Based on the original plan and user feedback, surgically modify ONLY the affected sections.

RULES:
- Read the original plan carefully
- Identify which sections need to be changed based on the user's feedback
- Rewrite ONLY those affected sections; keep unchanged sections exactly as they are
- If a day/place is removed, compress the itinerary accordingly
- If activities are added, integrate them naturally into the relevant sections
- Maintain the same format, tone, and structure as the original
- Return the modified plan with all changes incorporated

Focus on practical, spiritual, and pilgrimage-related content only.`;

// Extract sections from plan (using heading markers like ### or ##)
function extractPlanSections(plan: string): { title: string; content: string }[] {
  const sections: { title: string; content: string }[] = [];
  const lines = plan.split("\n");
  let currentTitle = "Overview";
  let currentContent = "";

  for (const line of lines) {
    const headingMatch = line.match(/^#{2,3}\s*\*{0,2}(.+?)\*{0,2}\s*$/);
    if (headingMatch) {
      // Save previous section
      if (currentContent.trim()) {
        sections.push({ title: currentTitle, content: currentContent.trim() });
      }
      currentTitle = headingMatch[1]?.trim() || "Section";
      currentContent = "";
    } else {
      currentContent += (currentContent ? "\n" : "") + line;
    }
  }

  // Save last section
  if (currentContent.trim()) {
    sections.push({ title: currentTitle, content: currentContent.trim() });
  }

  return sections.length > 0 ? sections : [{ title: "Overview", content: plan }];
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const body = (await req.json()) as ReplanTravelPlanRequest;
    const {
      originalPlan,
      userFeedback,
      mode,
      fromLocation,
      startDate,
      endDate,
      destinationName,
      destinationContext,
    } = body;

    if (!originalPlan || !userFeedback || !mode) {
      return errorResponse(
        "originalPlan, userFeedback, and mode are required",
        400
      );
    }

    if (mode !== "FULL_REGENERATE" && mode !== "SURGICAL_MODIFY") {
      return errorResponse(
        "mode must be FULL_REGENERATE or SURGICAL_MODIFY",
        400
      );
    }

    let newPlan: string;

    if (mode === "FULL_REGENERATE") {
      // Full regeneration with new context
      const userPrompt = `Create a completely new detailed spiritual pilgrimage plan with the following details:

- Travelling FROM: ${fromLocation}
- Start date: ${startDate}
- End date: ${endDate}
- Destination: ${destinationName}${destinationContext ? ` (${destinationContext})` : ""}

User feedback/requirements for this new plan: ${userFeedback}

Write a long, detailed plan (multiple paragraphs) covering: how to reach from ${fromLocation}, suggested number of days at the main destination and any nearby sacred sites, list of nearby temples or sacred places to visit, what the visitor can do there (darshan, rituals, meditation, festivals), and practical tips. Use clear section headings. Keep everything focused on spirituality and pilgrimage only.`;

      newPlan = await generateText(userPrompt, FULL_REGENERATE_SYSTEM_PROMPT, {
        temperature: 0.5,
        max_tokens: 6000,
      });
    } else {
      // Surgical modify - keep what works, change only affected parts
      const userPrompt = `Here is the original pilgrimage plan:

<ORIGINAL_PLAN>
${originalPlan}
</ORIGINAL_PLAN>

User feedback for modifications: ${userFeedback}

Based on this feedback, surgically modify the plan. Change ONLY the sections that are affected by the user's feedback. Keep all other sections exactly as they are. Maintain the same format and structure.`;

      newPlan = await generateText(userPrompt, SURGICAL_MODIFY_SYSTEM_PROMPT, {
        temperature: 0.5,
        max_tokens: 6000,
      });
    }

    // Prepare response with version metadata
    const changeSummary = `Modified using ${mode === "FULL_REGENERATE" ? "full regeneration" : "surgical modification"} mode. User feedback: "${userFeedback}"`;

    return jsonResponse({
      success: true,
      plan: newPlan || "Unable to replan.",
      mode: mode,
      changeSummary: changeSummary,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("Error in replan-travel-plan:", error);
    const message =
      error instanceof Error ? error.message : "Unknown error";
    if (message.includes("401") || message.includes("invalid or missing API key")) {
      return errorResponse(message, 503);
    }
    if (message.includes("OPENROUTER") || message.includes("API")) {
      return errorResponse("Plan modification is temporarily unavailable.", 503);
    }
    return errorResponse(`Failed to replan: ${message}`, 500);
  }
});
