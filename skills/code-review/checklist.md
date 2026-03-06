# Code Review Checklist

Detailed review criteria for Phase 3. Check each item for every changed file.

---

## Pattern Conformance

- [ ] **Naming**: Functions, variables, types, and files follow the same naming conventions as existing code in the same module (camelCase vs snake_case, prefix/suffix patterns, abbreviation style).
- [ ] **File structure**: The file is organized the same way as its siblings (imports at top, then types, then constants, then main exports -- or whatever the local convention is).
- [ ] **Import style**: Import ordering, grouping (external vs internal), and syntax (named vs default, `import type` usage) match existing files.
- [ ] **Export style**: Named exports vs default exports, barrel files, re-export patterns match the module's convention.
- [ ] **Error handling**: Uses the same error handling patterns as surrounding code (custom error classes, Result types, try/catch style, error propagation).
- [ ] **Logging**: Uses the same logger and log levels as surrounding code.
- [ ] **Comments**: Comment style and density matches the codebase (JSDoc vs inline, when comments are used vs when they are omitted).
- [ ] **Formatting**: Indentation, bracket style, trailing commas, semicolons match (should be enforced by linter, but verify).

## Correctness

- [ ] **Logic**: The code does what the PR description says it should do.
- [ ] **Edge cases**: Null/undefined inputs, empty arrays/objects, boundary values are handled.
- [ ] **Error paths**: All operations that can fail have proper error handling. No swallowed errors.
- [ ] **Async correctness**: Promises are awaited. No fire-and-forget unless intentional. No race conditions between concurrent operations.
- [ ] **State mutations**: No unintended side effects. Mutable state is managed carefully.
- [ ] **Type narrowing**: Type guards and narrowing are correct. No unsafe casts (`as`, `!`) unless justified.
- [ ] **API contracts**: Function signatures, return types, and thrown errors match what callers expect.
- [ ] **Boundary conditions**: Off-by-one errors, integer overflow, string encoding issues.

## Efficiency

- [ ] **Redundant operations**: No duplicate computations, repeated lookups, or unnecessary re-renders.
- [ ] **Algorithmic complexity**: Data structures and algorithms are appropriate for the data size. No O(n^2) where O(n) is possible.
- [ ] **Batching**: Operations that can be batched (DB queries, API calls, DOM updates) are batched.
- [ ] **Lazy evaluation**: Expensive computations are deferred until actually needed.
- [ ] **Memory**: No unnecessary copies of large data structures. No memory leaks from retained references or uncleaned listeners.
- [ ] **Network**: No unnecessary API calls. Requests are deduplicated or cached where appropriate.

## Dead Code

- [ ] **Unused imports**: Every import is referenced in the file.
- [ ] **Unused variables**: Every declared variable is read at least once.
- [ ] **Unused functions**: Every defined function is called (in this file or exported and called elsewhere).
- [ ] **Unreachable code**: No code after unconditional `return`, `throw`, `break`, or `continue`.
- [ ] **Commented-out code**: No blocks of commented-out code (should be deleted, not commented).
- [ ] **Dead branches**: No `if` branches that can never be true, no `switch` cases that can never match.
- [ ] **Unused parameters**: Function parameters are all used. Remove or prefix with `_` if intentionally unused.

## Security

- [ ] **Input validation**: All external input (user input, API responses, URL params) is validated before use.
- [ ] **Injection**: No SQL injection, XSS, command injection, or path traversal vulnerabilities.
- [ ] **Secrets**: No hardcoded API keys, passwords, tokens, or connection strings.
- [ ] **Auth**: Authentication and authorization checks are present where required.
- [ ] **Data exposure**: No sensitive data leaked in logs, error messages, or API responses.

## Type Safety

- [ ] **No `any`**: Avoid `any` unless truly necessary. Use `unknown` and narrow instead.
- [ ] **Narrow types**: Types are as specific as possible (string literals vs `string`, specific union vs broad type).
- [ ] **Generic correctness**: Generic type parameters are constrained appropriately.
- [ ] **Null safety**: Optional values are checked before use. Strict null checks are respected.
- [ ] **Return types**: Functions have explicit return types where the codebase convention requires them.
