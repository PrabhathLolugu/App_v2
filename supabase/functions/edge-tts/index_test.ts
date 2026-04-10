import { assertEquals } from "https://deno.land/std@0.224.0/assert/assert_equals.ts";
import { normalizeLocaleInput } from "./index.ts";

Deno.test("normalizeLocaleInput accepts language and locale forms", () => {
  assertEquals(normalizeLocaleInput("hi"), "hi-IN");
  assertEquals(normalizeLocaleInput("hi-IN"), "hi-IN");
  assertEquals(normalizeLocaleInput("UR_pk"), "ur-PK");
  assertEquals(normalizeLocaleInput("odia"), "or-IN");
  assertEquals(normalizeLocaleInput("sa"), "en-IN");
});

Deno.test("normalizeLocaleInput rejects unknown values", () => {
  assertEquals(normalizeLocaleInput("xx-YY"), null);
  assertEquals(normalizeLocaleInput(""), null);
});
