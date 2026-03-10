## PR #1 Review

### Medium

- **`skills/sync-skills/SKILL.md` (Dependencies section)** -- `## Dependencies` is a pattern deviation: no other skill SKILL.md file has this section; all skills track dependencies exclusively in `catalog.json`. The section is also incomplete — it lists only `gh CLI` but omits `git`, which is used by `git clone` in Step 5. Remove the section to conform to the established convention.

- **`skills/redeploy-frontend/SKILL.md` (Step 0 vs Step 4 pattern mismatch)** -- Step 0 searches for the string `// redeploy:` (no space after colon) to locate the timestamp file, but Step 4 matches against `// redeploy: ` (with a trailing space). If an existing comment was written without a space (e.g., `// redeploy:2026-03-05T14:23:00Z`), Step 4 will fail to match it and insert a duplicate comment at the top of the file instead of replacing the existing one. Align both steps to use the same pattern.

- **`skills/redeploy-frontend/SKILL.md` (Step 4 example)** -- The example result still shows `import type { Metadata } from "next"`, which is Next.js-specific and directly contradicts the PR's stated goal of removing project-specific references. The final commit message even cites "Remove Next.js-specific language from redeploy-frontend Step 3" but Step 4 was not updated. Replace the example with a generic line such as `// ... rest of file`.

- **`catalog.json` (sync-skills trigger style)** -- The trigger `"user pastes a github.com/timi-ty/cursor-skills URL"` is a behavioral description, inconsistent with every other trigger in the catalog, which are all short user-spoken phrases (`"redeploy"`, `"code review"`, `"commit my changes"`, etc.). The description field already captures this activation condition. Remove the behavioral trigger; it doesn't match catalog conventions.

### Low

- **`skills/sync-skills/SKILL.md` (Step 3, Windows CRLF)** -- `gh api ... --jq '.content | @base64d'` decodes remote file content with LF line endings, while local files on Windows may use CRLF. A byte-for-byte comparison will produce false-positive UPDATED classifications for every skill on Windows. Add a note to strip `\r` from both sides before comparing.

- **`skills/sync-skills/SKILL.md` (Step 5, no error-path cleanup)** -- If a copy operation fails mid-execution, the instruction only says to clean up "after all changes are applied." There is no error-path cleanup. Add: "If any copy fails, clean up the temp directory and abort with an error message listing what was and was not applied."

- **`skills/commit-agent-changes/SKILL.md` (misplaced multi-repo note)** -- The "If changes span multiple repositories, confirm each repo separately" closing note now sits immediately after the new Step 3 body, making it read as a tail note for Step 3 rather than a closing note for all of Phase 2. Move it to just before the `---` separator and `### Phase 3` header, or add a brief label like "**Note (all of Phase 2)**:" to clarify its scope.
