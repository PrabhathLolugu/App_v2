# Android Manual Verification Checklist: English Translation Fix

**Test Device**: Android Emulator or Physical Device  
**Prerequisite**: Firebase/Supabase credentials configured in app  
**Test Duration**: ~5-10 minutes

---

## Phase 1: Load Hindi Story (Baseline State)

- [ ] **Step 1.1**: Open MyItihas app on Android
  - **Expected**: Home screen loads with story list
  
- [ ] **Step 1.2**: Tap any **Hindi-language story** (verify Devanagari script visible in preview)
  - **Expected**: Story detail page opens
  - **Expected UI**: 
    - Story title displays in Hindi/Devanagari
    - Story content renders in Devanagari script
    - Language dropdown shows "हिंदी" (Hindi) as source language badge/indicator
    - **Translate to:** dropdown near bottom shows available languages (English, Hindi, Tamil, Kannada, etc.)

- [ ] **Step 1.3**: Verify initial device state
  - **Expected**: No "Translate again" button visible yet (refresh button only appears when a translation is selected/cached)

---

## Phase 2: Select English Translation (Primary Fix Test)

- [ ] **Step 2.1**: Tap **"English"** from the **"Translate to:"** dropdown
  - **Expected UI**: 
    - Dropdown closes
    - Selected language changes to "English"
    - **Spinner/Loading indicator appears** below language selector (circular progress widget)
    - Dropdown is **disabled/grayed out** during translation
    - **"Translate again" refresh button** becomes visible and appears **disabled** (grayed out) during translation
    
- [ ] **Step 2.2**: Wait for translation API call to complete (~2-8 seconds)
  - **Expected Network Behavior** (verify via logcat or network monitor):
    - Supabase edge function endpoint called: `/functions/v1/translate-story`
    - Request params: `targetLang: "en"`, story content, language style info
    - **This call MUST happen** (this is the primary fix verification)
    
  - **Expected UI Change**: 
    - Spinner disappears
    - Dropdown becomes **enabled** again
    - **"Translate again" button becomes enabled** (color = primary brand color, clickable)
    - Story content **transitions to English** (text now in Latin script, readable English prose)
    - Header/title may remain in original language or be translated (depends on story object structure)

- [ ] **Step 2.3**: Verify English content is readable
  - **Expected**: Full story text in natural English, not partial or corrupted
  - **Example**: Original "एक राजा था..." (There was once a king...) → English version displays full coherent narrative
  - **Pass Criterion**: English text flows naturally without truncation or encoding artifacts

---

## Phase 3: Test Cached Translation Behavior (Default Cache Reuse)

- [ ] **Step 3.1**: *Do NOT click refresh button.* Instead, tap dropdown and **re-select English again**
  - **Expected Behavior**: 
    - Dropdown opens, English is visually marked as selected
    - Tap English again
    - **NO spinner appears** (cache reuse path)
    - Dropdown closes immediately
    - Story content **remains in English** (no flicker or reload)
    - **"Translate again" button remains visible and enabled**
  - **Pass Criterion**: Zero translation API calls occur (verified via logcat: no `/functions/v1/translate-story` endpoint call)

- [ ] **Step 3.2**: Switch to a different language (e.g., Hindi)
  - **Expected**: 
    - Spinner appears (API call for Hindi, or cache reuse if already cached)
    - Content switches back to Hindi/Devanagari
    - "Translate again" button state updates

---

## Phase 4: Test "Translate Again" Refresh Button (Secondary Fix Test)

- [ ] **Step 4.1**: Tap **"English"** from dropdown again
  - **Expected**: Same as Step 2.1-2.2 (spinner, API call, English content, refresh button enabled)

- [ ] **Step 4.2**: **Immediately after English translation loads and button is enabled**, tap the **"Translate again" (refresh) button**
  - **Button Visual State**:
    - Icon: refresh_rounded icon (circular arrow)
    - Color: Matches primary theme color (likely the app's brand blue/green)
    - Tooltip (hover): "Translate again"
    
  - **Expected Behavior on Tap**:
    - Button **immediately shows spinner** (circular progress, replacing refresh icon)
    - Button becomes **disabled** (grayed out appearance, not clickable)
    - Dropdown becomes **disabled**
    - **Another API call MUST be made** (this is the explicit refresh verification - bypasses cache)
    
- [ ] **Step 4.3**: Wait for refresh translation to complete (~2-8 seconds)
  - **Expected Network Behavior** (verify via logcat):
    - Supabase edge function called **again** with same params
    - **This is a SECOND API call** to `/functions/v1/translate-story` (proves cache was bypassed)
  
  - **Expected UI Change**:
    - Spinner disappears
    - Button returns to refresh icon state (enabled)
    - Dropdown returns to enabled state
    - Story content **may be identical** or slightly different (different LLM generation variation)

- [ ] **Step 4.4**: Verify content after refresh
  - **Pass Criterion**: 
    - Content is still valid English
    - May have minor wording differences from first translation (expected: different LLM generation)
    - Not identical word-for-word to first translation (confirms fresh API call, not cache reuse)

---

## Phase 5: Edge Case - English Source to English (Same Language)

- [ ] **Step 5.1**: Navigate to an **English-language story** (or previous story may have English source language metadata)
  - **Expected**: Story content displays in English, language dropdown shows "English" as source

- [ ] **Step 5.2**: Tap **"English"** from the **"Translate to:"** dropdown
  - **Expected Behavior** (Same-language guard):
    - Spinner appears for ~1-2 seconds
    - Spinner disappears
    - Dropdown returns to enabled state
    - **Toast/Snackbar message appears** at bottom of screen:
      - **Text**: "Story is already in English. You can try regenerating again for a fresh variation."
      - **Duration**: ~3-5 seconds, dismisses automatically
    - Content **remains unchanged** (no translation call expected)
    - **"Translate again" button remains visible and enabled**

- [ ] **Step 5.3**: Tap **"Translate again" button** with English→English selected
  - **Expected**: 
    - Spinner appears on button
    - Button/dropdown disabled
    - **API call SHOULD occur** (forceRefresh=true overrides same-language guard; regenerates fresh English)
    - After completion: new English content with wording variations

---

## Phase 6: Network Verification (Optional, Advanced)

**If using Android Emulator with Logcat access:**

- [ ] Open Logcat in Android Studio
  - Filter for: `translate-story` or `edge-function` or `supabase`
  
- [ ] **Step 2 (First translation)**: Should see 1 API request
  ```
  [Supabase] POST /functions/v1/translate-story
  Response: 200 OK, translated story object
  ```

- [ ] **Step 3 (Re-select English without refresh)**: Should see 0 new API requests
  ```
  [Cache] Returning cached English translation
  ```

- [ ] **Step 4 (Translate again click)**: Should see 1 new API request
  ```
  [Supabase] POST /functions/v1/translate-story (via refresh event)
  Response: 200 OK, fresh translated story object
  ```

---

## Summary: Pass/Fail Criteria

| Checkpoint | Pass Condition | Critical? |
|-----------|---|---|
| **2.2** | English translation API call occurs on first English selection | ✅ **CRITICAL** |
| **2.3** | Translated content is readable English | ✅ **CRITICAL** |
| **3.1** | Re-selecting English uses cache (NO API call) | ✅ **CRITICAL** |
| **4.2-4.3** | "Translate again" button triggers fresh API call (2nd call) | ✅ **CRITICAL** |
| **4.4** | Fresh translation content differs from cached (not identical) | ✅ **CRITICAL** |
| **5.2** | Same-language toast appears, no API call | ✅ Important |
| **5.3** | Same-language refresh with button DOES trigger API call | ✅ Important |

---

## Troubleshooting

| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| **Step 2.2: No spinner, English doesn't appear** | API call failed or returns null | Check Supabase credentials, edge function deployment status, OpenRouter API key. Check logcat for 400/500 errors. |
| **Step 3.1: Spinner appears again on re-select** | Cache not working | Check Story.attributes.translations map. Verify cache was written after Step 2. |
| **Step 4.2: "Translate again" button not visible** | Refresh event not registering | Check generated_story_detail_page.dart line 1065-1069, verify StoryDetailTranslationRefreshRequested event is dispatched. |
| **Step 4.3: Only 1 API call occurs (not 2)** | forceRefresh flag not working | Check story_detail_bloc.dart _translateToLanguage method, verify forceRefresh parameter is passed and checked (line 438). |
| **Step 5.2: No toast message appears** | Message not implemented | Check story_detail_bloc.dart line 443-445 for same-language message. |

---

## Notes for Tester

- **Duration**: Expect 3-5 seconds per translation API call (network dependent)
- **API Costs**: Each step 2, 4, 5.3 will consume OpenRouter tokens (LLM calls)
- **Idempotent**: Running this checklist multiple times is safe; cache only helps performance
- **Offline**: App will fail gracefully at step 2.2 if device loses internet access (check logcat for details)

---

**Test Result**: 
- [ ] All critical checkpoints **PASSED** → Fix verified, ready for release
- [ ] Any critical checkpoint **FAILED** → Return to development for debugging
