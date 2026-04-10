# Story Generator API Documentation

This API generates authentic Indian scripture-based stories using Google's Gemini AI. It is hosted as a Supabase Edge Function.

## 🔗 Endpoint

**URL**: `https://<your-project-ref>.supabase.co/functions/v1/generate-story`
**Method**: `POST`
**Content-Type**: `application/json`

## 🔐 Authentication

Requires a valid Supabase Auth token (JWT) or Anon Key.

**Header**:
```http
Authorization: Bearer <YOUR_SUPABASE_ANON_KEY>
```

> **Note**: For authenticated client-side calls (e.g. Flutter), the token will be automatically handled if you use the Supabase client.

## 📦 Request Body

The request body must be a JSON object with the following structure:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `prompt` | Object | Yes | Details about the story to generate |
| `options` | Object | Yes | Configuration for language, format, and length |
| `userId` | UUID | **Yes** | The UUID of the user requesting the story (Required by database) |

### `prompt` Object

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `scripture` | String | Source scripture name | "Ramayana", "Mahabharata" |
| `storyType` | String | Type of story | "Heroic Tale", "Moral Lesson" |
| `theme` | String | Central theme | "Dharma", "Courage" |
| `mainCharacter` | String | Focus character | "Arjuna", "Sita" |
| `setting` | String | Story setting | "Kurukshetra" |

### `options` Object

| Field | Type | Description |
|-------|------|-------------|
| `language` | Object | `{ "displayName": "English", "code": "en" }` |
| `format` | Object | `{ "displayName": "Narrative", "description": "Storytelling" }` |
| `length` | Object | `{ "displayName": "Short", "approximateWords": 500 }` |

## 📤 Example Request

```json
{
  "prompt": {
    "scripture": "Ramayana",
    "storyType": "Futher Tale",
    "theme": "Devotion",
    "mainCharacter": "Hanuman",
    "setting": "Lanka"
  },
  "options": {
    "language": {
      "displayName": "English",
      "code": "en"
    },
    "format": {
      "displayName": "Narrative",
      "description": "Standard storytelling"
    },
    "length": {
      "displayName": "Medium",
      "approximateWords": 1000
    }
  },
  "userId": "550e8400-e29b-41d4-a716-446655440000"
}
```

## 📥 Response Body

Success (200 OK) returns a `Story` object:

```json
{
  "id": "generated-uuid",
  "title": "Hanuman's Leap",
  "story": "## The Great Leap\n\nHanuman stood at the edge...",
  "scripture": "Ramayana",
  "quotes": "> \"Jai Shri Ram\"\n> Quotes in markdown",
  "trivia": "- Trivia point 1\n- Trivia point 2",
  "activity": "Reflective activity description...",
  "lesson": "The moral lesson of the story...",
  "attributes": {
    "storyType": "Heroic Tale",
    "theme": "Devotion",
    "references": ["Sundara Kanda"],
    "tags": ["Devotion", "Strength"]
  },
  "authorId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2024-03-20T10:00:00Z"
}
```

## ⚠️ Error Codes

| Code | Reason |
|------|--------|
| `200` | Success |
| `400` | Bad Request (Missing `prompt`, `options`, or `userId`) |
| `500` | Internal Server Error (Gemini API failure, DB error) |

## 💻 Integration Examples

### cURL

```bash
curl -L -X POST 'https://<project-ref>.supabase.co/functions/v1/generate-story' \
-H 'Authorization: Bearer <YOUR_ANON_KEY>' \
-H 'Content-Type: application/json' \
--data-raw '{
    "prompt": {"scripture": "Ramayana"},
    "options": {
        "language": {"displayName": "English", "code": "en"},
        "format": {"displayName": "Narrative", "description": "Story"},
        "length": {"displayName": "Short", "approximateWords": 500}
    },
    "userId": "YOUR_USER_ID_HERE"
}'
```
