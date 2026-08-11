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
