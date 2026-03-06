---
name: redeploy-frontend
description: Trigger a Vercel redeploy of the frontend by pushing a harmless comment change to dev. Use when the user says "redeploy", "redeploy frontend", "trigger vercel deploy", or "trigger redeploy".
---

# Redeploy Frontend

Push a trivial comment change to the `dev` branch of `ngriid-quasar-frontend` to trigger a Vercel redeploy. Auto-fixes prettier formatting issues before pushing.

## Workflow

### Step 1: Ensure clean working tree

Run from the frontend repo:

```bash
cd ngriid-quasar-frontend
git status --porcelain
```

If there is any output, **abort** and tell the user:

> "There are uncommitted changes in ngriid-quasar-frontend. Stash or commit them before redeploying."

### Step 2: Switch to dev and pull latest

```bash
git checkout dev
git pull origin dev
```

### Step 3: Local pre-build check and auto-fix

Run the build locally to catch failures before pushing:

```bash
pnpm run build
```

**If the build passes**, continue to Step 4.

**If the build fails**, inspect the output:

- **Prettier-only failure** -- the output contains `[warn]` lines listing files and ends with `Code style issues found`. The `next build` phase never ran. Auto-fix:

  ```bash
  pnpm run format
  ```

  Then re-run `pnpm run build` to confirm the fix.
  - If the re-run **passes**, continue to Step 4. The formatted files will be staged alongside the timestamp change in Step 5.
  - If the re-run **fails** with a different error, treat as non-trivial (see below).

- **Non-trivial failure** (ESLint errors, TypeScript type errors, Next.js build errors) -- **abort** and report the full build output to the user. Ask follow-up questions about how to resolve before pushing.

### Step 4: Update the redeploy timestamp

Open `src/app/layout.tsx`. Look for an existing line matching the pattern `// redeploy: <timestamp>`.

- If the line exists, **replace** it with a new UTC timestamp: `// redeploy: <current UTC ISO 8601>`
- If no such line exists, **insert** `// redeploy: <current UTC ISO 8601>` as the very first line of the file.

Example result:

```typescript
// redeploy: 2026-03-05T14:23:00Z
import type { Metadata } from "next";
```

Use the current time from the system (e.g., `date -u +%Y-%m-%dT%H:%M:%SZ` in shell) to generate the timestamp.

### Step 5: Commit and push

If prettier auto-fixed files in Step 3, stage everything and use the format-aware message:

```bash
git add .
git commit -m "chore: format and trigger redeploy"
git push origin dev
```

If no prettier fixes were needed (only the timestamp changed), stage just the layout file:

```bash
git add src/app/layout.tsx
git commit -m "chore: trigger redeploy"
git push origin dev
```

### Step 6: Confirm

Report the push result to the user. Include the commit hash from the output.
