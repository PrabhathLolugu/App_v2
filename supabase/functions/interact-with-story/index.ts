import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { generateText, generateJSON } from "../_shared/openrouter.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { retryWithBackoff } from "../_shared/retry.ts";

/**
 * Interact With Story Edge Function
 *
 * Handles two interaction types:
 * - expand: Continues a story with 3-4 new paragraphs in the story's language
 * - characters: Returns structured JSON analysis of a character
 */

interface InteractRequest {
  story_title: string;
  story_content: string;
  interaction_type: "expand" | "characters";
  character_name?: string;
  story_language: string;
}

interface CharacterAnalysis {
  name: string;
  appearance: string;
  personality_traits: string[];
  key_actions: string[];
  role: string;
  scripture_background: string;
  divine_attributes: string[];
  relationships: string[];
}

const LITERARY_SYSTEM_PROMPT =
  "You are an expert literary analyst specializing in Indian scriptures and cultural stories. " +
  "You have deep knowledge of the Vedas, Upanishads, Puranas, Mahabharata, Ramayana, and other sacred texts.";

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const body: InteractRequest = await req.json();
    const {
      story_title,
      story_content,
      interaction_type,
      character_name,
      story_language,
    } = body;

    if (!story_title || !story_content || !interaction_type) {
      return errorResponse(
        "story_title, story_content, and interaction_type are required",
        400
      );
    }

    if (interaction_type === "expand") {
      const userPrompt =
        `Continue the following story titled "${story_title}" with 3-4 new paragraphs. ` +
        `Write the continuation in ${story_language}. ` +
        `Maintain the same tone, style, and narrative voice. ` +
        `The continuation should flow naturally from where the story left off.\n\n` +
        `Story so far:\n${story_content}`;

      const response = await retryWithBackoff(async () => {
        return await generateText(userPrompt, LITERARY_SYSTEM_PROMPT, {
          temperature: 0.8,
          max_tokens: 2048,
        });
      });

      return jsonResponse({ response });
    } else if (interaction_type === "characters") {
      if (!character_name) {
        return errorResponse(
          "character_name is required for characters interaction type",
          400
        );
      }

      const userPrompt =
        `Analyze the character "${character_name}" from the story titled "${story_title}". ` +
        `Respond in ${story_language}. ` +
        `Provide a detailed structured analysis as a JSON object with the following fields:\n` +
        `- name: The character's full name\n` +
        `- appearance: Physical description and appearance\n` +
        `- personality_traits: Array of personality traits\n` +
        `- key_actions: Array of key actions in the story\n` +
        `- role: The character's role in the story\n` +
        `- scripture_background: Background from scriptures\n` +
        `- divine_attributes: Array of divine or special attributes\n` +
        `- relationships: Array of relationships with other characters\n\n` +
        `Story:\n${story_content}`;

      const characterData = await retryWithBackoff(async () => {
        return await generateJSON<CharacterAnalysis>(
          userPrompt,
          LITERARY_SYSTEM_PROMPT,
          {
            temperature: 0.7,
            max_tokens: 2048,
          }
        );
      });

      return jsonResponse(characterData);
    } else {
      return errorResponse(
        `Unknown interaction_type: ${interaction_type}. Must be "expand" or "characters".`,
        400
      );
    }
  } catch (error) {
    console.error("Error in interact-with-story:", error);
    const message = error instanceof Error ? error.message : "Unknown error";

    if (message.includes("429") || message.toLowerCase().includes("rate")) {
      return errorResponse(
        "AI servers are busy. Please try again in a moment.",
        503
      );
    }

    return errorResponse(`Interaction error: ${message}`, 500);
  }
});
