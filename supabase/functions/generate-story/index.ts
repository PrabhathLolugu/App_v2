import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { generateJSON } from "../_shared/openrouter.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { retryWithBackoff } from "../_shared/retry.ts";

/**
 * Story Generator Edge Function
 *
 * Generates stories based on Indian scriptures using OpenRouter AI
 * and stores them in Supabase database
 */

// Types matching Flutter entities
interface StoryPrompt {
  scripture?: string;
  scriptureSubtype?: string;
  storyType?: string;
  theme?: string;
  mainCharacter?: string;
  setting?: string;
  rawPrompt?: string;
  isRawPrompt?: boolean;
}

interface GeneratorOptions {
  language: {
    displayName: string;
    code: string;
  };
  format: {
    displayName: string;
    description: string;
  };
  length: {
    displayName: string;
    description: string;
    approximateWords: number;
  };
}

interface StoryRequest {
  prompt: StoryPrompt;
  options: GeneratorOptions;
  userId?: string;
}

interface StoryAttributes {
  storyType: string;
  theme: string;
  mainCharacterType: string;
  storySetting: string;
  timeEra: string;
  narrativePerspective: string;
  languageStyle: string;
  emotionalTone: string;
  narrativeStyle: string;
  plotStructure: string;
  storyLength: string;
  references: string[];
  tags: string[];
  characters: string[];
}

interface GeneratedStoryData {
  title: string;
  story: string;
  quotes: string;
  trivia: string;
  activity: string;
  lesson: string;
  attributes: StoryAttributes;
}

interface StoryResponse {
  id: string;
  title: string;
  scripture: string;
  story: string;
  quotes: string;
  trivia: string;
  activity: string;
  lesson: string;
  attributes: StoryAttributes;
  imageUrl?: string;
  author?: string;
  publishedAt?: string;
  createdAt: string;
  likes: number;
  views: number;
  isFavorite: boolean;
  authorId?: string;
  commentCount: number;
  shareCount: number;
  isLikedByCurrentUser: boolean;
}

/**
 * Builds a comprehensive system prompt for story generation
 */
function buildSystemPrompt(prompt: StoryPrompt, options: GeneratorOptions): string {
  const scripture = prompt.scripture || "Indian scriptures";
  const wordCount = options.length.approximateWords;
  const language = options.language.displayName;
  const narrativeStyle = options.format.displayName;

  return `You are an expert storyteller and scholar of Indian scriptures including the Ramayana, Mahabharata, Vedas, Puranas, and other sacred texts. Your task is to generate an engaging, educational, and authentic story.

**Story Requirements:**
- Scripture Source: ${scripture}
- Story Type: ${prompt.storyType || "Any appropriate type"}
- Theme: ${prompt.theme || "Moral and ethical teachings"}
- Main Character: ${prompt.mainCharacter || "Characters from the scripture"}
- Setting: ${prompt.setting || "Traditional setting from the scripture"}
- Language: ${language}
- Narrative Style: ${narrativeStyle} (${options.format.description})
- Length: Approximately ${wordCount} words (${options.length.displayName})

**Output Format (CRITICAL - MUST FOLLOW EXACTLY):**
You must respond ONLY with a valid JSON object. The JSON must have this exact structure:

{
  "title": "Engaging title for the story",
  "story": "The complete story text formatted in markdown. Use headings (##), paragraphs, **bold** for emphasis, *italics* for character thoughts, and > blockquotes for important dialogues or verses. Make it visually appealing and easy to read.",
  "quotes": "2-3 relevant quotes or verses from the scripture in markdown format, each on a new line with > blockquote formatting",
  "trivia": "3-5 interesting facts about the story, characters, or historical context in markdown with bullet points",
  "activity": "A practical activity or exercise readers can do to connect with the story's teachings (in markdown)",
  "lesson": "The moral or philosophical lesson from the story, explained clearly in markdown",
  "attributes": {
    "storyType": "${prompt.storyType || "Scriptural Tale"}",
    "theme": "${prompt.theme || "Dharma and Righteousness"}",
    "mainCharacterType": "${prompt.mainCharacter || "Divine Being"}",
    "storySetting": "${prompt.setting || "Ancient India"}",
    "timeEra": "The historical or scriptural era (e.g., Treta Yuga, Dwapara Yuga)",
    "narrativePerspective": "The narrative perspective used (e.g., Third Person, First Person)",
    "languageStyle": "${language}",
    "emotionalTone": "The primary emotional tone (e.g., Inspirational, Reflective, Heroic)",
    "narrativeStyle": "${narrativeStyle}",
    "plotStructure": "The story structure used (e.g., Hero's Journey, Moral Lesson, Battle Epic)",
    "storyLength": "${options.length.displayName}",
    "references": ["List of scripture references used"],
    "tags": ["relevant", "tags", "for", "categorization"],
    "characters": ["Main characters in the story"]
  }
}

**Story Content Guidelines:**
1. **Authenticity**: Base the story on authentic scripture sources
2. **Engagement**: Make it captivating and emotionally resonant
3. **Education**: Include historical and cultural context
4. **Accessibility**: Write for modern readers while respecting tradition
5. **Markdown Formatting**: Use proper markdown for structure and readability

**Remember:**
- Output ONLY the JSON object, no other text
- All text fields should use markdown formatting
- Be culturally sensitive and respectful
- Ensure accuracy in scriptural references
- Make the story appropriate for all ages`;
}

/**
 * Generates story using OpenRouter API
 */
async function generateStoryWithOpenRouter(
  prompt: StoryPrompt,
  options: GeneratorOptions
): Promise<GeneratedStoryData> {
  const systemPrompt = buildSystemPrompt(prompt, options);

  // Build user prompt based on input
  let userPrompt: string;
  if (prompt.isRawPrompt && prompt.rawPrompt) {
    userPrompt = prompt.rawPrompt;
  } else {
    const parts = [];
    parts.push(`Generate a story from ${prompt.scripture || "Indian scriptures"}`);
    if (prompt.storyType) parts.push(`Story Type: ${prompt.storyType}`);
    if (prompt.theme) parts.push(`Theme: ${prompt.theme}`);
    if (prompt.mainCharacter) parts.push(`Main Character: ${prompt.mainCharacter}`);
    if (prompt.setting) parts.push(`Setting: ${prompt.setting}`);
    userPrompt = parts.join(". ");
  }

  const fullPrompt = systemPrompt + "\n\nUser Request: " + userPrompt;

  const result = await retryWithBackoff(async () => {
    return await generateJSON<GeneratedStoryData>(fullPrompt, undefined, {
      temperature: 0.8,
      max_tokens: 8192,
      top_p: 0.95,
    });
  });

  return result;
}

/**
 * Stores story in Supabase database (both stories and generated_stories tables)
 */
async function storeStory(
  storyData: GeneratedStoryData,
  supabase: ReturnType<typeof createSupabaseClient>,
  language: string,
  userId: string
): Promise<string> {
  // Store in 'stories' table (for existing app compatibility)
  const storyRecord = {
    title: storyData.title,
    content: storyData.story,
    user_id: userId,
    language: language,
    metadata: {
      scripture: storyData.attributes.references?.[0] || "Unknown",
      quotes: storyData.quotes,
      trivia: storyData.trivia,
      activity: storyData.activity,
      lesson: storyData.lesson,
    },
    attributes: storyData.attributes,
    published_at: new Date().toISOString(),
    created_at: new Date().toISOString(),
    likes: 0,
    views: 0,
    comment_count: 0,
    share_count: 0,
    author_id: userId,
  };

  const { data: storiesData, error: storiesError } = await supabase
    .from("stories")
    .insert([storyRecord])
    .select()
    .single();

  if (storiesError) {
    console.error("Database Error (stories):", storiesError);
    throw new Error(`Failed to store story: ${storiesError.message}`);
  }

  // Also store in 'generated_stories' table for new functionality
  const generatedStoryRecord = {
    user_id: userId,
    title: storyData.title,
    story_content: storyData.story,
    moral: storyData.lesson,
    source: storyData.attributes.references?.[0] || "Unknown",
    characters: storyData.attributes.characters || [],
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  const { error: genError } = await supabase
    .from("generated_stories")
    .insert([generatedStoryRecord]);

  if (genError) {
    console.error("Warning: Failed to insert into generated_stories:", genError);
    // Don't fail the request, stories table insert succeeded
  }

  return storiesData.id;
}

/**
 * Main request handler
 */
Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    // Parse request body
    const requestBody: StoryRequest = await req.json();
    const { prompt, options, userId } = requestBody;

    // Validate required fields
    if (!prompt || !options) {
      return errorResponse("Missing required fields: prompt and options", 400);
    }

    if (!options.language?.displayName || !options.language?.code) {
      return errorResponse("Missing required field: options.language", 400);
    }

    if (!options.format?.displayName) {
      return errorResponse("Missing required field: options.format", 400);
    }

    if (!options.length?.approximateWords) {
      return errorResponse("Missing required field: options.length", 400);
    }

    if (!userId) {
      return errorResponse("Missing required field: userId", 400);
    }

    // Create Supabase admin client (bypasses RLS for server-side operations)
    const supabase = createSupabaseClient();

    // Generate story using OpenRouter
    console.log("Generating story with OpenRouter...");
    const storyData = await generateStoryWithOpenRouter(prompt, options);

    // Store story in database
    console.log("Storing story in database...");
    const storyId = await storeStory(
      storyData,
      supabase,
      options.language.displayName,
      userId
    );

    // Prepare response
    const response: StoryResponse = {
      id: storyId,
      title: storyData.title,
      scripture: storyData.attributes.references?.[0] || prompt.scripture || "Unknown",
      story: storyData.story,
      quotes: storyData.quotes,
      trivia: storyData.trivia,
      activity: storyData.activity,
      lesson: storyData.lesson,
      attributes: storyData.attributes,
      author: "AI Generated",
      publishedAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
      likes: 0,
      views: 0,
      isFavorite: false,
      authorId: userId,
      commentCount: 0,
      shareCount: 0,
      isLikedByCurrentUser: false,
    };

    return jsonResponse(response);
  } catch (error: unknown) {
    console.error("Error in generate-story function:", error);
    const errorMessage = error instanceof Error ? error.message : "Internal server error";

    if (errorMessage.includes("429") || errorMessage.toLowerCase().includes("rate")) {
      return errorResponse(
        "Story generation servers are busy. Please try again in a moment.",
        503
      );
    }

    return errorResponse(errorMessage, 500);
  }
});
