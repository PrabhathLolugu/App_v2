# MyItihas Website Prompt: Rich Share Preview + Deep Link Landing Page

You are working in the MyItihas website repository. This is a TypeScript-based web app, and your task is to implement rich share previews and deep-link landing pages for public post URLs.

## Goal

Make shared MyItihas post links behave like modern social links:

- When the URL is shared in WhatsApp or similar apps, it should show a rich preview card with a title, description, and image.
- When the URL is opened in a browser, it should show a branded landing page with an Open App button and app store links.
- When the MyItihas app is installed, the same URL should open the correct post in the app via Android App Links and iOS Universal Links.
- Existing older link shapes should continue working if they are already in circulation.

## Important Context

- The app-side canonical post URL is `https://myitihas.com/post/{id}`.
- Canonical story URL is `https://myitihas.com/story/{id}`.
- Canonical video URL is `https://myitihas.com/video/{id}`.
- Legacy link shapes may still exist and should be supported as compatibility aliases where reasonable.
- The website codebase is TypeScript, so implement this using the repository’s existing TypeScript framework and conventions.

## What To Build

### 1. Rich Metadata for Social Preview

Implement server-rendered metadata for public content pages so crawlers can generate proper previews without needing to execute the client app.

For each canonical content route, return HTML containing at least:

- `og:title`
- `og:description`
- `og:image`
- `og:url`
- `og:type`
- `twitter:card`
- `twitter:title`
- `twitter:description`
- `twitter:image`

Requirements:

- The metadata must be present in the initial HTML response.
- Do not rely on client-side JavaScript to inject metadata after load.
- Use real post data from the backend/API, not placeholder demo text.
- If a post is missing or unavailable, return a graceful fallback preview page with a useful message and app install links.

### 2. Branded Landing Page

Create a clean landing page for browser visits to post URLs.

The page should:

- Show a meaningful title and short description.
- Show the preview image if available.
- Include a prominent Open App button.
- Include Google Play and App Store links if available.
- Be responsive and mobile-friendly.
- Feel intentional and branded, not like a default error screen.

### 3. Deep Link Compatibility

Ensure that public routes can open the correct in-app content.

Support:

- `/post/{id}`
- `/story/{id}`
- `/video/{id}`

Also keep support for any legacy link patterns that already exist in the wild, either through redirects or aliases.

The browser landing page should not block the app from opening on installed devices.

### 4. App Link / Universal Link Association Files

Add or update the files under the public `.well-known` path:

- `/.well-known/assetlinks.json`
- `/.well-known/apple-app-site-association`

Requirements:

- Include the canonical paths for posts, stories, and videos.
- Add legacy paths too if they must remain supported.
- Serve the iOS association file with the correct JSON content type.
- Keep the files valid and reachable from `https://myitihas.com`.

### 5. Real Data Fetching

The preview page must use actual post data.

- Reuse an existing API, page loader, server action, route handler, or backend endpoint if one already exists.
- If necessary, add a small TypeScript server route or endpoint that fetches the post by ID and returns metadata or rendered HTML.
- Do not hardcode preview text.

### 6. Tests and Verification

Add tests or validation for the behavior you introduce.

At minimum, verify:

- The generated HTML contains the expected Open Graph and Twitter tags.
- Canonical `/post/{id}` URLs are recognized correctly.
- Legacy link formats still resolve if they are still supposed to work.
- The landing page includes the Open App CTA.

## Implementation Guidance

Use the existing framework patterns in the website repo.

If the site is:

- Next.js: prefer server components, metadata APIs, route handlers, or SSR/ISR as appropriate.
- Express/Koa/Fastify: create server routes that return metadata-rich HTML for public content pages.
- Vite/static: add a preview server or edge endpoint for social crawler requests, since a purely client-rendered page will not produce rich previews reliably.

## Acceptance Criteria

- Sharing a MyItihas post link in WhatsApp shows a rich preview card instead of a plain text URL.
- Opening the same link in a browser shows a polished landing page.
- Opening the same link on a device with the app installed navigates directly to the correct post.
- Older shared links do not break.
- The solution is limited to share preview and deep-link behavior, with no unrelated feature changes.

## Constraints

- Do not refactor unrelated website features.
- Keep the implementation focused and minimal.
- Follow the repository’s existing TypeScript style, linting, routing, and folder conventions.
- Prefer server-side or framework-native metadata generation over client-side hacks.

## Suggested Work Plan

1. Locate the current public route handling for `/post/{id}` and related content pages.
2. Find the backend/API layer that can fetch post data by ID.
3. Add server-side metadata generation for the public post route.
4. Add or update the landing page UI for browser visits.
5. Add `.well-known` association files for Android and iOS.
6. Add compatibility for any old link shapes that still need to work.
7. Add tests and verify the final HTML output.

## Notes

- If the website repo already has a canonical route pattern different from `/post/{id}`, preserve the existing route design but make sure the externally shared URL matches the app link strategy.
- If you need a fallback strategy, prefer a server-rendered preview page that also serves as the landing page and metadata source.
- Keep the output clean and production-ready.
