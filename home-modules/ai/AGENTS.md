This is a NixOS system. Use `nix-shell -p ... --run "..."` for one time commands that require packages that are not in your current environment.

# General Style Guidelines:
- Do not include comments in final code output.

# Style Guidelines (Typescript):
- Always make sure to use `undefined` instead of `null` whenever possible.
- Never use the `any` type.
- Always make sure to use arrow functions
- Always make sure to use ternary functions over if statements. An exception is when executing statements that do not return values. do not do something like `booleanVar && functionCall()` or `booleanVar ? sideEffect1() : sideEffect2();`
- Do not try/catch, or throw exceptions, unless the API requires you to throw.
- Always use async/await, never use .then or .catch. You are also allowed to void Promises if you do not need to wait or depend on the return value.
- When using bun APIs, you should use `import Bun from 'bun';`
- Always prefer to use map/filter/reduce/other functional methods over traditional for loop processing.
- Always strive to use const whenever possible, and adapting the code to work with a const style.
- Always use `type` over `interface`

Always use `rg` and `fd` over `grep` and `find`

Always write idiomatic code using idioms provided by the language, regardless of the language.

Always use `bun` instead of `npm` unless the project is not using bun. Determine this via the lockfile being used. If no lockfile is present, use bun.

Do NOT use mock data unless you are explicitly told to do so.

The following rules apply to every task in this project unless explicitly overridden.

## Rule 1 — Think Before Coding

State assumptions explicitly. If uncertain, ask rather than guess.
Present multiple interpretations when ambiguity exists.
Push back when a simpler approach exists.
Stop when confused. Name what's unclear.

## Rule 2 — Simplicity First

Minimum code that solves the problem. Nothing speculative.
No features beyond what was asked. No abstractions for single-use code.
Test: would a senior engineer say this is overcomplicated? If yes, simplify.

## Rule 3 — Surgical Changes

Touch only what you must. Clean up only your own mess.
Don't "improve" adjacent code, comments, or formatting.
Don't refactor what isn't broken. Match existing style.

## Rule 4 — Goal-Driven Execution

Define success criteria. Loop until verified.
Don't follow steps. Define success and iterate.
Strong success criteria let you loop independently.

## Rule 5 — Use the model only for judgment calls

Use me for: classification, drafting, summarization, extraction.
Do NOT use me for: routing, retries, deterministic transforms.
If code can answer, code answers.

## Rule 6 — Surface conflicts, don't average them

If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

## Rule 7 — Read before you write

Before adding code, read exports, immediate callers, shared utilities.
"Looks orthogonal" is dangerous. If unsure why code is structured a way, ask.

## Rule 8 — Tests verify intent, not just behavior

Tests must encode WHY behavior matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

## Rule 9 — Checkpoint after every significant step

Summarize what was done, what's verified, what's left.
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

## Rule 10 — Match the codebase's conventions, even if you disagree

Conformance > taste inside the codebase.
If you genuinely think a convention is harmful, surface it. Don't fork silently.

## Rule 11 — Fail loud

"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

