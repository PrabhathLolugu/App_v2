/**
 * Shared chat helpers: dynamic suggestions, user state analysis, safety.
 * Ported from server_fastapi.py for edge chat-service.
 */
import type { ChatMessage, ChatMode } from "./types.ts";

const HARMFUL_KEYWORDS = [
  "suicide", "kill", "murder", "violence", "terror", "harm", "hurt",
  "die", "death", "end life", "self harm", "hurt myself", "want to die",
];

const PREFERRED_NAME_PATTERNS: RegExp[] = [
  /\b(?:call me|you can call me|please call me|you may call me)\s+([\p{L}\p{M}0-9][\p{L}\p{M}0-9'\- ]{0,39})\b/iu,
  /\b(?:my preferred name is|my preferred name's|i prefer to be called|i prefer being called)\s+([\p{L}\p{M}0-9][\p{L}\p{M}0-9'\- ]{0,39})\b/iu,
];

function normalizeNameCandidate(input: string | undefined): string | undefined {
  if (!input) return undefined;
  const normalized = input
    .trim()
    .replace(/\s+/g, " ")
    .replace(/^[^\p{L}\p{M}0-9]+/u, "")
    .replace(/[^\p{L}\p{M}0-9]+$/u, "");

  if (!normalized) return undefined;
  if (normalized.length > 40) return undefined;
  return normalized;
}

export function extractFallbackCallName(rawName: string | undefined): string | undefined {
  const normalized = normalizeNameCandidate(rawName);
  if (!normalized) return undefined;

  const parts = normalized.split(" ").filter(Boolean);
  if (parts.length <= 1) return parts[0];
  if (parts.length === 2) return parts[0];
  return parts[parts.length - 1];
}

export function extractPreferredCallNameFromText(text: string | undefined): string | undefined {
  if (!text) return undefined;
  for (const pattern of PREFERRED_NAME_PATTERNS) {
    const match = text.match(pattern);
    if (!match || !match[1]) continue;
    const normalized = normalizeNameCandidate(match[1]);
    if (normalized) return normalized;
  }
  return undefined;
}

export function resolveEffectiveCallName(input: {
  explicitPreferredCallName?: string;
  chatPreferredCallName?: string;
  profilePreferredCallName?: string;
  fallbackExtractedName?: string;
}): string | undefined {
  return normalizeNameCandidate(input.explicitPreferredCallName)
    ?? normalizeNameCandidate(input.chatPreferredCallName)
    ?? normalizeNameCandidate(input.profilePreferredCallName)
    ?? normalizeNameCandidate(input.fallbackExtractedName);
}

export function hasHarmfulContent(lastUserMessage: string): boolean {
  const lower = lastUserMessage.trim().toLowerCase();
  return HARMFUL_KEYWORDS.some((k) => lower.includes(k));
}

export function getSafetyContext(mode: ChatMode): string {
  switch (mode) {
    case "friend":
      return "\n\nSAFETY ALERT: The user has mentioned potentially harmful topics. Respond with divine wisdom about the sanctity of life, guide them toward love and peace, and offer support and hope.";
    case "story_scholar":
      return "\n\nSAFETY ALERT: The user has mentioned potentially harmful topics. Respond with scholarly wisdom about the sanctity of life from Indian scriptures, guide them toward dharma and positive actions, and offer academic support.";
    case "philosophical":
      return "\n\nSAFETY ALERT: The user has mentioned potentially harmful topics. Respond with profound philosophical wisdom from the Bhagavad Gita about the sanctity of life, guide them toward dharma and spiritual growth, and offer divine guidance.";
    case "tourist_guide":
      return "\n\nSAFETY ALERT: The user has mentioned potentially harmful topics. Respond with wisdom about the sanctity of life and sacred places, guide them toward positive spiritual experiences, and offer hope and guidance.";
    default:
      return "\n\nSAFETY ALERT: The user has mentioned potentially harmful topics. Respond with wisdom about the sanctity of life and offer support and hope.";
  }
}

export function getLatestUserMessage(messages: ChatMessage[]): string {
  for (let i = messages.length - 1; i >= 0; i--) {
    if (messages[i].role === "user") {
      return (messages[i].content || "").toLowerCase();
    }
  }
  return "";
}

export interface PhilosophicalUserState {
  emotional_state: "neutral" | "crisis" | "stressed" | "confused" | "seeking";
  problem_type: "general" | "relationship" | "work" | "spiritual" | "decision";
  guidance_level: string;
  response_approach: string;
}

function determinePhilosophicalApproach(
  emotionalState: string,
  problemType: string,
  _guidanceLevel: string,
): string {
  if (emotionalState === "crisis") return "crisis_intervention";
  if (emotionalState === "stressed" && problemType === "work") return "practical_wisdom";
  if (emotionalState === "confused" && problemType === "decision") return "decision_guidance";
  if (problemType === "relationship") return "relationship_wisdom";
  if (problemType === "spiritual") return "deep_philosophy";
  return "balanced_guidance";
}

export function analyzePhilosophicalUserState(messages: ChatMessage[]): PhilosophicalUserState {
  const latest = getLatestUserMessage(messages);
  if (!messages.length) {
    return {
      emotional_state: "neutral",
      problem_type: "general",
      guidance_level: "standard",
      response_approach: "balanced_guidance",
    };
  }

  const stressIndicators = [
    "stress", "stressed", "anxiety", "anxious", "worried", "worry", "tension", "tense",
    "overwhelmed", "pressure", "burden", "struggling", "difficult", "hard", "tough",
    "crisis", "problem", "trouble", "confused", "lost", "helpless", "hopeless",
  ];
  const confusionIndicators = [
    "confused", "confusion", "don't understand", "unclear", "lost", "direction",
    "purpose", "meaning", "why", "what should", "how to", "guidance", "help",
  ];
  const seekingIndicators = [
    "guidance", "advice", "help", "support", "wisdom", "teach", "learn",
    "understand", "explain", "clarity", "peace", "solution", "answer",
  ];
  const crisisIndicators = [
    "crisis", "emergency", "urgent", "desperate", "suicide", "end", "give up",
    "hopeless", "worthless", "failure", "defeat", "broken", "destroyed",
  ];
  const relationshipIndicators = ["relationship", "family", "marriage", "love", "partner", "spouse", "parent", "child"];
  const workIndicators = ["work", "job", "career", "business", "money", "financial", "success", "failure"];
  const spiritualIndicators = ["spiritual", "soul", "dharma", "karma", "moksha", "enlightenment", "meditation"];
  const decisionIndicators = ["decision", "choose", "option", "path", "direction", "right", "wrong"];

  const has = (arr: string[]) => arr.some((k) => latest.includes(k));

  let emotional_state: PhilosophicalUserState["emotional_state"] = "neutral";
  if (has(crisisIndicators)) emotional_state = "crisis";
  else if (has(stressIndicators)) emotional_state = "stressed";
  else if (has(confusionIndicators)) emotional_state = "confused";
  else if (has(seekingIndicators)) emotional_state = "seeking";

  let problem_type: PhilosophicalUserState["problem_type"] = "general";
  if (has(relationshipIndicators)) problem_type = "relationship";
  else if (has(workIndicators)) problem_type = "work";
  else if (has(spiritualIndicators)) problem_type = "spiritual";
  else if (has(decisionIndicators)) problem_type = "decision";

  let guidance_level = "standard";
  if (emotional_state === "crisis") guidance_level = "intensive";
  else if (emotional_state === "stressed" || emotional_state === "confused") guidance_level = "supportive";
  else if (emotional_state === "seeking") guidance_level = "detailed";

  const response_approach = determinePhilosophicalApproach(emotional_state, problem_type, guidance_level);

  return {
    emotional_state,
    problem_type,
    guidance_level,
    response_approach,
  };
}

export interface TouristGuideIntent {
  response_length: "brief" | "standard" | "moderate" | "detailed";
}

export function analyzeUserIntentForTouristGuide(messages: ChatMessage[]): TouristGuideIntent {
  const latest = getLatestUserMessage(messages);
  if (!messages.length) {
    return { response_length: "standard" };
  }

  const expansionKeywords = [
    "tell me more", "more about", "expand", "continue", "go on", "elaborate",
    "detailed", "in depth", "comprehensive", "thorough", "extensive",
    "what else", "anything else", "further", "additional", "more details",
    "explain more", "describe more", "share more", "tell me everything",
    "full story", "complete", "entire", "whole", "all about",
  ];
  const continuationKeywords = [
    "continue", "go on", "what happened next", "then what", "after that",
    "next", "further", "more", "keep going", "don't stop",
  ];
  const briefKeywords = [
    "brief", "short", "quick", "summary", "overview", "just tell me",
    "in short", "briefly", "quickly", "simple", "basic",
  ];
  const sameTopicIndicators = [
    "this place", "here", "this temple", "this site", "this location",
    "the same", "it", "that", "the place", "the temple",
  ];

  const wantsExpansion = expansionKeywords.some((k) => latest.includes(k));
  const wantsContinuation = continuationKeywords.some((k) => latest.includes(k));
  const wantsBrief = briefKeywords.some((k) => latest.includes(k));
  const topicDepth = messages.length > 4 ? "deep" : messages.length > 2 ? "intermediate" : "initial";
  const isSameTopic = sameTopicIndicators.some((k) => latest.includes(k));

  let response_length: TouristGuideIntent["response_length"] = "standard";
  if (wantsBrief) response_length = "brief";
  else if (wantsExpansion || wantsContinuation || (topicDepth === "deep" && isSameTopic)) response_length = "detailed";
  else if (topicDepth === "intermediate" || isSameTopic) response_length = "moderate";

  return { response_length };
}

const CONTEXT_KEYWORDS: Record<string, string[]> = {
  spiritual: ["meditation", "yoga", "enlightenment", "soul", "consciousness", "awakening", "spiritual", "divine", "god", "prayer"],
  family: ["family", "parent", "child", "mother", "father", "sibling", "marriage", "wedding", "divorce"],
  health: ["sick", "ill", "pain", "healing", "medicine", "doctor", "hospital", "health", "wellness", "fitness"],
  education: ["study", "learn", "school", "college", "university", "exam", "student", "teacher", "knowledge"],
  money: ["money", "financial", "debt", "rich", "poor", "wealth", "investment", "business", "job", "salary"],
  death: ["death", "dying", "funeral", "mourning", "grief", "loss", "passed away", "heaven", "afterlife"],
  purpose: ["purpose", "meaning", "goal", "dream", "ambition", "mission", "calling", "destiny"],
  fear: ["afraid", "fear", "scared", "anxiety", "worry", "panic", "terror", "phobia"],
  anger: ["angry", "mad", "furious", "rage", "irritated", "frustrated", "annoyed"],
  love: ["love", "romance", "relationship", "dating", "heart", "affection", "passion", "crush"],
  success: ["success", "achievement", "victory", "win", "accomplish", "triumph", "excellence"],
  failure: ["fail", "failure", "mistake", "error", "defeat", "lose", "disappointment"],
  time: ["time", "age", "old", "young", "future", "past", "present", "moment", "eternity"],
  karma: ["karma", "action", "deed", "consequence", "result", "cause", "effect"],
  dharma: ["dharma", "duty", "responsibility", "righteousness", "moral", "ethical", "virtue"],
  moksha: ["moksha", "liberation", "freedom", "salvation", "enlightenment", "nirvana", "bliss"],
};

function detectSpiritualTopic(latest: string): string | null {
  for (const [topic, keywords] of Object.entries(CONTEXT_KEYWORDS)) {
    if (keywords.some((k) => latest.includes(k))) return topic;
  }
  return null;
}

const GENERIC_SUGGESTIONS = ["Tell me more", "What else?", "How to apply?", "Thank you"];

/** Regex to match a line that starts with SUGGESTIONS: (case-insensitive) */
const SUGGESTIONS_LINE_REGEX = /^\s*SUGGESTIONS:\s*(.+)$/im;

/**
 * Extract LLM-generated suggestion keywords from the response and return cleaned response.
 * The LLM is instructed to end with a line: SUGGESTIONS: A | B | C | D
 * Returns the response with that line stripped, and the parsed suggestions (or empty array).
 */
export function extractSuggestionsFromLlmResponse(responseText: string): {
  cleanResponse: string;
  suggestions: string[];
} {
  if (!responseText || typeof responseText !== "string") {
    return { cleanResponse: responseText ?? "", suggestions: [] };
  }
  const lines = responseText.split("\n");
  let suggestions: string[] = [];
  const cleanedLines: string[] = [];
  for (const line of lines) {
    const match = line.match(SUGGESTIONS_LINE_REGEX);
    if (match) {
      const part = match[1].trim();
      suggestions = part
        .split("|")
        .map((s) => s.trim())
        .filter((s) => s.length > 0)
        .slice(0, 4);
      continue; // omit this line from clean response
    }
    cleanedLines.push(line);
  }
  const cleanResponse = cleanedLines.join("\n").trimEnd();
  return { cleanResponse, suggestions };
}

export function padSuggestions(suggestions: string[], maxLen: number): string[] {
  const out = [...suggestions];
  while (out.length < maxLen) {
    out.push(GENERIC_SUGGESTIONS[out.length % GENERIC_SUGGESTIONS.length]);
  }
  return out.slice(0, maxLen);
}

/**
 * Generate exactly 4 context-aware suggestion strings based on messages, mode, and response.
 */
export function generateDynamicSuggestions(
  messages: ChatMessage[],
  mode: ChatMode,
  responseText: string,
): string[] {
  if (!messages.length || messages.length < 2) {
    return padSuggestions([], 4);
  }

  const latest = getLatestUserMessage(messages);
  const responseLower = (responseText || "").toLowerCase();
  const hasInMessageOrResponse = (...terms: string[]) =>
    terms.some((t) => latest.includes(t) || responseLower.includes(t));

  let suggestions: string[] = [];

  if (mode === "philosophical") {
    const userState = analyzePhilosophicalUserState(messages);
    const { emotional_state, problem_type } = userState;
    const spiritualTopic = detectSpiritualTopic(latest);

    if (emotional_state === "crisis") {
      suggestions = ["How to find hope?", "What gives life meaning?", "How to be strong?", "Thank you"];
    } else if (emotional_state === "stressed") {
      if (latest.includes("work") || latest.includes("job")) {
        suggestions = ["How to reduce work stress?", "What is the solution?", "How to find work-life balance?", "Career guidance?"];
      } else if (latest.includes("health") || latest.includes("sick")) {
        suggestions = ["How to heal?", "What is the solution?", "How to find peace?", "Health guidance?"];
      } else {
        suggestions = ["How to reduce stress?", "What is the solution?", "How to find peace?", "More guidance please"];
      }
    } else if (emotional_state === "confused") {
      if (spiritualTopic === "purpose") {
        suggestions = ["What is my purpose?", "How to find meaning?", "What should I do?", "Life guidance?"];
      } else if (spiritualTopic === "dharma") {
        suggestions = ["What is my dharma?", "How to fulfill duty?", "What is right?", "Dharma guidance?"];
      } else {
        suggestions = ["What should I do?", "How to decide?", "What is right?", "Explain more"];
      }
    } else if (problem_type === "relationship") {
      if (latest.includes("love") || latest.includes("romance")) {
        suggestions = ["What is true love?", "How to love properly?", "Relationship guidance?", "Love advice?"];
      } else if (latest.includes("family")) {
        suggestions = ["How to improve family?", "What about family duty?", "How to respect parents?", "Family guidance?"];
      } else {
        suggestions = ["How to improve relationships?", "What about love?", "How to forgive?", "Relationship advice"];
      }
    } else if (spiritualTopic === "karma") {
      suggestions = ["What is karma?", "How to improve karma?", "Karma and actions?", "Karma guidance?"];
    } else if (spiritualTopic === "moksha") {
      suggestions = ["What is moksha?", "How to achieve liberation?", "Path to enlightenment?", "Moksha guidance?"];
    } else if (spiritualTopic === "spiritual" && (latest.includes("meditation") || latest.includes("yoga"))) {
      suggestions = ["How to meditate?", "Meditation techniques?", "Benefits of meditation?", "Spiritual practice?"];
    } else if (spiritualTopic === "death") {
      suggestions = ["What happens after death?", "How to face death?", "Death and rebirth?", "Afterlife guidance?"];
    } else if (spiritualTopic === "fear") {
      suggestions = ["How to overcome fear?", "What is courage?", "How to be brave?", "Fear guidance?"];
    } else if (spiritualTopic === "anger") {
      suggestions = ["How to control anger?", "What is patience?", "How to forgive?", "Anger management?"];
    } else if (spiritualTopic === "success") {
      suggestions = ["What is true success?", "How to achieve goals?", "Success and humility?", "Achievement guidance?"];
    } else if (spiritualTopic === "failure") {
      suggestions = ["How to handle failure?", "What to learn from mistakes?", "How to rise again?", "Failure guidance?"];
    } else if (spiritualTopic === "time") {
      suggestions = ["What is time?", "How to use time wisely?", "Time and eternity?", "Time guidance?"];
    } else if (spiritualTopic === "health") {
      suggestions = ["How to heal?", "Health and spirituality?", "Mind-body connection?", "Healing guidance?"];
    } else if (spiritualTopic === "money") {
      suggestions = ["What is wealth?", "Money and spirituality?", "How to be content?", "Wealth guidance?"];
    } else if (spiritualTopic === "education") {
      suggestions = ["What is true knowledge?", "Learning and wisdom?", "How to study?", "Education guidance?"];
    } else {
      suggestions = ["Tell me more", "What else?", "How to apply this?", "Thank you"];
    }
  } else if (mode === "tourist_guide") {
    if (hasInMessageOrResponse("temple")) {
      suggestions = ["Temple history?", "How to visit?", "What to see?", "More temples?"];
    } else if (hasInMessageOrResponse("kurukshetra")) {
      suggestions = ["Battle details?", "What happened here?", "Arjuna's story?", "More about war?"];
    } else if (hasInMessageOrResponse("ramayana")) {
      suggestions = ["Rama's journey?", "Sita's story?", "Hanuman's role?", "More Ramayana?"];
    } else if (hasInMessageOrResponse("mahabharata")) {
      suggestions = ["Mahabharata stories?", "Pandavas story?", "Kauravas story?", "More Mahabharata?"];
    } else if (hasInMessageOrResponse("krishna")) {
      suggestions = ["Krishna's stories?", "Krishna's teachings?", "Krishna's miracles?", "More about Krishna?"];
    } else if (hasInMessageOrResponse("hanuman")) {
      suggestions = ["Hanuman's stories?", "Hanuman's powers?", "Hanuman temples?", "More about Hanuman?"];
    } else if (latest.includes("pilgrimage") || latest.includes("yatra")) {
      suggestions = ["Pilgrimage routes?", "How to plan yatra?", "Sacred places?", "Pilgrimage guidance?"];
    } else if (hasInMessageOrResponse("arjuna")) {
      suggestions = ["Arjuna's dilemma?", "Arjuna's story?", "Arjuna's lessons?", "More about Arjuna?"];
    } else if (hasInMessageOrResponse("draupadi")) {
      suggestions = ["Draupadi's story?", "Draupadi's strength?", "Draupadi's devotion?", "More about Draupadi?"];
    } else if (hasInMessageOrResponse("bhishma")) {
      suggestions = ["Bhishma's story?", "Bhishma's vow?", "Bhishma's wisdom?", "More about Bhishma?"];
    } else if (hasInMessageOrResponse("drona")) {
      suggestions = ["Drona's story?", "Drona's teachings?", "Drona's dilemma?", "More about Drona?"];
    } else if (hasInMessageOrResponse("karna")) {
      suggestions = ["Karna's story?", "Karna's generosity?", "Karna's loyalty?", "More about Karna?"];
    } else if (hasInMessageOrResponse("vishnu")) {
      suggestions = ["Vishnu's avatars?", "Vishnu's stories?", "Vishnu's temples?", "More about Vishnu?"];
    } else if (hasInMessageOrResponse("shiva")) {
      suggestions = ["Shiva's stories?", "Shiva's temples?", "Shiva's teachings?", "More about Shiva?"];
    } else if (hasInMessageOrResponse("durga")) {
      suggestions = ["Durga's stories?", "Durga's temples?", "Durga's power?", "More about Durga?"];
    } else if (latest.includes("festival") || latest.includes("celebration")) {
      suggestions = ["Festival details?", "How to celebrate?", "Festival significance?", "More festivals?"];
    } else if (hasInMessageOrResponse("dwarka")) {
      suggestions = ["Dwarka's history?", "Krishna's Dwarka?", "How to visit Dwarka?", "More about Dwarka?"];
    } else if (latest.includes("varanasi") || latest.includes("kashi") || latest.includes("banaras")) {
      suggestions = ["Varanasi's significance?", "Ghats of Varanasi?", "How to visit Varanasi?", "More about Varanasi?"];
    } else if (hasInMessageOrResponse("mathura")) {
      suggestions = ["Mathura's history?", "Krishna's birthplace?", "How to visit Mathura?", "More about Mathura?"];
    } else if (hasInMessageOrResponse("ayodhya")) {
      suggestions = ["Ayodhya's history?", "Rama's Ayodhya?", "How to visit Ayodhya?", "More about Ayodhya?"];
    } else if (hasInMessageOrResponse("hastinapur")) {
      suggestions = ["Hastinapur's history?", "Pandavas' capital?", "How to visit Hastinapur?", "More about Hastinapur?"];
    } else if (latest.includes("indus") || latest.includes("saraswati")) {
      suggestions = ["Ancient rivers?", "Saraswati's story?", "Indus civilization?", "More about rivers?"];
    } else if (latest.includes("yoga") || latest.includes("meditation")) {
      suggestions = ["Yoga origins?", "Meditation places?", "Spiritual practices?", "More about yoga?"];
    } else if (latest.includes("architecture") || hasInMessageOrResponse("temple")) {
      suggestions = ["Temple architecture?", "Ancient building?", "How temples built?", "More architecture?"];
    } else if (latest.includes("war") || latest.includes("battle")) {
      suggestions = ["Battle details?", "War strategies?", "Warriors' stories?", "More about wars?"];
    } else {
      suggestions = ["Tell me more", "What else?", "How to visit?", "More places?"];
    }
  } else if (mode === "friend") {
    if (latest.includes("stress") || latest.includes("worried")) {
      suggestions = ["How to relax?", "What to do?", "Help me", "Thank you"];
    } else if (latest.includes("happy") || latest.includes("good")) {
      suggestions = ["Share more", "Tell me more", "What's next?", "Great!"];
    } else if (latest.includes("sad") || latest.includes("depressed")) {
      suggestions = ["How to be happy?", "What to do?", "Cheer me up", "Help me"];
    } else if (latest.includes("angry") || latest.includes("mad")) {
      suggestions = ["How to calm down?", "What to do?", "Help me", "Thank you"];
    } else if (latest.includes("tired") || latest.includes("exhausted")) {
      suggestions = ["How to rest?", "What to do?", "Help me", "Thank you"];
    } else if (latest.includes("lonely") || latest.includes("alone")) {
      suggestions = ["How to feel connected?", "What to do?", "Help me", "Thank you"];
    } else if (latest.includes("excited") || latest.includes("thrilled")) {
      suggestions = ["Share more!", "Tell me more!", "What's next?", "Amazing!"];
    } else if (latest.includes("confused") || latest.includes("lost")) {
      suggestions = ["How to find clarity?", "What to do?", "Help me", "Thank you"];
    } else if (latest.includes("grateful") || latest.includes("thankful")) {
      suggestions = ["Share more!", "Tell me more!", "What's next?", "Wonderful!"];
    } else if (latest.includes("hopeful") || latest.includes("optimistic")) {
      suggestions = ["Share your hope!", "Tell me more!", "What's next?", "Great!"];
    } else if (latest.includes("curious") || latest.includes("wondering")) {
      suggestions = ["Ask more questions!", "What else?", "Tell me more!", "Great!"];
    } else {
      suggestions = ["How are you?", "What's up?", "Tell me more", "Thanks"];
    }
  } else {
    // story_scholar, auto: static fallback
    switch (mode) {
      case "story_scholar":
        suggestions = ["Tell me more", "Related stories?", "Scripture source?", "Thanks"];
        break;
      default:
        suggestions = ["Tell me more", "What else?", "How to apply?", "Thank you"];
    }
  }

  return padSuggestions(suggestions, 4);
}
