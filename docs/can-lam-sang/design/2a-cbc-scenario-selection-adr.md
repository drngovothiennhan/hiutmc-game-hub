# ADR — CBC scenario selection

- Start accepts only the requested level.
- The server counts this user's existing attempts and computes
  `hashtextextended(user_id::text || chr(31) || attempt_count, 0)`.
- It first considers approved scenarios at the requested level that this user has never attempted.
- A deterministic hash of the user seed plus each scenario key orders candidates; the first candidate wins.
- If all approved scenarios at that level have been attempted, the same deterministic ordering is used across the full approved set.
- No `random()` is used.
- `pattern_id` is never used as an array index; scenario keys are stable internal keys derived from the pattern identity, level, sex and variant.
- The scenario's public ID is opaque and generated from SHA-256 of the internal scenario key plus a fixed seed salt.

This is proposal-only for Step 2a-2. QA concurrency verification remains pending architect permission.
