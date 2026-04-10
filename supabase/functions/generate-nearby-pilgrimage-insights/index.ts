declare const Deno: {
  env: {
    get(name: string): string | undefined;
  };
  serve(
    handler: (req: Request) => Response | Promise<Response>,
  ): void;
};

import { generateJSON, type GenerationConfig } from "../_shared/openrouter.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";

// Use specific model for nearby insights
const NEARBY_MODEL = "google/gemini-2.5-flash-lite";

interface NearbyLocationInput {
  id?: number;
  name: string;
  region?: string;
  type?: string;
  tradition?: string;
  description?: string;
  distanceKm?: number;
  latitude?: number;
  longitude?: number;
}

interface NearbyInsightsRequest {
  selectedLocation: NearbyLocationInput;
  nearbyLocations: NearbyLocationInput[];
  radiusKm?: number;
}

interface NearbySiteInsight {
  name: string;
  shortDescription: string;
  bestTimeToVisit: string;
  pilgrimTips: string;
}

interface NearbyInsightsModelOutput {
  selectedSummary: string;
  selectedBestTime: string;
  nearby: NearbySiteInsight[];
}

const SYSTEM_PROMPT = `You are a pilgrimage travel assistant for Indian sacred journeys.

Return ONLY valid JSON with this exact schema:
{
  "selectedSummary": "2-3 sentence summary about the selected sacred location",
  "selectedBestTime": "best months or season with short rationale",
  "nearby": [
    {
      "name": "exact nearby site name from input",
      "shortDescription": "1-2 sentence spiritual significance summary",
      "bestTimeToVisit": "short season/month guidance",
      "pilgrimTips": "short practical spiritual tip"
    }
  ]
}

Rules:
- Keep answers concise and practical.
- Use culturally respectful and devotional tone.
- Do not invent unrelated attractions.
- Keep each field under 40 words.
- Use only provided site names in nearby[].`;

function truncate(input: string, max = 340): string {
  const value = input.trim();
  if (value.length <= max) return value;
  return `${value.slice(0, max - 1)}...`;
}

function fallbackInsights(req: NearbyInsightsRequest): NearbyInsightsModelOutput {
  const selectedName = req.selectedLocation.name;
  const selectedSummary = (req.selectedLocation.description ?? "").trim().length > 0
    ? truncate(req.selectedLocation.description!)
    : `${selectedName} is a significant pilgrimage destination and a strong spiritual anchor for nearby sacred travel.`;

  const nearby = req.nearbyLocations.map((site) => {
    const shortDescription = (site.description ?? "").trim().length > 0
      ? truncate(site.description!, 220)
      : `${site.name} is revered by pilgrims for darshan, prayer, and spiritual reflection.`;

    return {
      name: site.name,
      shortDescription,
      bestTimeToVisit: "October to March is usually comfortable for pilgrims.",
      pilgrimTips: "Arrive early for darshan and keep local temple customs in mind.",
    };
  });

  return {
    selectedSummary,
    selectedBestTime: "October to March is ideal for most pilgrim routes in this region.",
    nearby,
  };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  if (req.method !== "POST") {
    return errorResponse("Method not allowed", 405);
  }

  try {
    const body = (await req.json()) as NearbyInsightsRequest;
    const selectedLocation = body.selectedLocation;
    const nearbyLocations = Array.isArray(body.nearbyLocations)
      ? body.nearbyLocations
      : [];

    if (!selectedLocation?.name || nearbyLocations.length === 0) {
      return errorResponse("selectedLocation and nearbyLocations are required", 400);
    }

    const compactNearby = nearbyLocations.slice(0, 12).map((site) => ({
      name: site.name,
      region: site.region,
      type: site.type,
      tradition: site.tradition,
      description: truncate(site.description ?? "", 220),
      distanceKm: site.distanceKm,
    }));

    const aiPrompt = JSON.stringify(
      {
        selectedLocation: {
          name: selectedLocation.name,
          region: selectedLocation.region,
          type: selectedLocation.type,
          tradition: selectedLocation.tradition,
          description: truncate(selectedLocation.description ?? "", 280),
        },
        radiusKm: body.radiusKm ?? 200,
        nearbyLocations: compactNearby,
      },
      null,
      2
    );

    let generated: NearbyInsightsModelOutput;
    try {
      generated = await generateJSON<NearbyInsightsModelOutput>(aiPrompt, SYSTEM_PROMPT, {
        temperature: 0.35,
        max_tokens: 2200,
        model: NEARBY_MODEL,
      });
    } catch (_) {
      generated = fallbackInsights({
        selectedLocation,
        nearbyLocations: compactNearby,
        radiusKm: body.radiusKm,
      });
    }

    const mergedNearby = compactNearby.map((site) => {
      const aiMatch = generated.nearby?.find(
        (item) => item.name.toLowerCase().trim() === site.name.toLowerCase().trim()
      );

      return {
        name: site.name,
        shortDescription:
          aiMatch?.shortDescription?.trim() ||
          truncate(site.description ?? "A spiritually meaningful nearby pilgrimage site."),
        bestTimeToVisit:
          aiMatch?.bestTimeToVisit?.trim() ||
          "October to March is generally comfortable for pilgrims.",
        pilgrimTips:
          aiMatch?.pilgrimTips?.trim() ||
          "Visit during morning hours and follow local temple etiquette.",
      };
    });

    return jsonResponse({
      selectedSummary:
        generated.selectedSummary?.trim() || fallbackInsights({ selectedLocation, nearbyLocations }).selectedSummary,
      selectedBestTime:
        generated.selectedBestTime?.trim() ||
        "October to March is usually the most suitable season for pilgrimage travel.",
      nearby: mergedNearby,
    });
  } catch (error) {
    console.error("generate-nearby-pilgrimage-insights error", error);
    const message = error instanceof Error ? error.message : "Unknown error";
    return errorResponse(`Failed to generate nearby insights: ${message}`, 500);
  }
});
