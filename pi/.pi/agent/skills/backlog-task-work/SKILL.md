---
name: backlog-task-work
description: >
  Implement an existing Backlog.md task end-to-end via the `backlog` CLI. Covers
  the full lifecycle: claim the task (set In Progress + assign), write an
  Implementation Plan and get user approval before coding, append progress notes,
  check off Acceptance Criteria and Definition of Done items, write a PR-style
  Final Summary, and mark the task Done. Use when the user asks to start, pick
  up, work on, continue, or finish a backlog task (e.g. "work on task 42",
  "start task-7", "finish this task"). For creating new tasks instead, use
  `backlog-task-create`.
---

# Backlog.md — Working a Task

## Golden rule

**Never edit task files directly.** All operations go through the `backlog` CLI.

- Read: `backlog task <id> --plain`
- Search: `backlog search "topic" --plain`

## Lifecycle (follow in order)

### 1. Read the task

```bash
backlog task <id> --plain
```

Review attached **references** (related code/URLs) and **documentation** (design docs, specs) before planning.

### 2. Claim it

Set status to In Progress and assign yourself. Do this **first**, before planning.

```bash
backlog task edit <id> -s "In Progress" -a @myself
```

### 3. Write the Implementation Plan

Think through HOW you'll satisfy each acceptance criterion. Quickly verify the tools/dependencies you'll need are available. Then save the plan:

```bash
backlog task edit <id> --plan $'1. Research codebase for prior art\n2. Implement X\n3. Add tests for Y\n4. Manually verify Z'
```

**Then share the plan with the user and wait for approval.** Do not write code until the user approves or explicitly says to skip review.

### 4. Implement

Code. Run tests. As you make progress, append notes — don't replace them:

```bash
backlog task edit <id> --append-notes $'- Added new API endpoint\n- Updated tests\n- TODO: monitor staging deploy'
```

Notes are a time-ordered progress log: progress, decisions, blockers. Short bullets/paragraphs, not a wall of text.

### 5. Check off Acceptance Criteria as you complete them

```bash
# Multiple at once (preferred)
backlog task edit <id> --check-ac 1 --check-ac 2 --check-ac 3

# Mixed operations also work
backlog task edit <id> --check-ac 1 --uncheck-ac 2 --remove-ac 3
```

⚠️ Only implement what's in the AC. If scope grows, **either** update the AC first (`--ac "New requirement"`) **or** create a follow-up task (`backlog task create "..."`). Don't quietly expand scope.

### 6. Check off Definition of Done items

```bash
backlog task edit <id> --check-dod 1 --check-dod 2
```

### 7. Write the Final Summary (PR description)

Treat it as a PR description that will be pasted directly into GitHub. Cover **what changed**, **why**, **user impact**, **tests run**, and **risks/follow-ups** when relevant. Avoid one-liners unless the change is truly trivial.

```bash
backlog task edit <id> --final-summary $'Added Final Summary support across CLI/MCP/Web/TUI to separate PR summaries from progress notes.\n\nChanges:\n- Added `finalSummary` to task types and markdown serialization.\n- CLI/MCP/Web/TUI now render and edit Final Summary.\n\nTests:\n- bun test src/test/final-summary.test.ts'
```

Append more detail later with `--append-final-summary`, or wipe with `--clear-final-summary`.

### 8. Mark Done

A task is **Done** only when **all** of these are true:

- ✅ All acceptance criteria checked
- ✅ All Definition of Done items checked
- ✅ Final Summary written
- ✅ Tests pass, lint clean, no regressions
- ✅ Docs updated if relevant
- ✅ Self-reviewed

Then:

```bash
backlog task edit <id> -s Done
```

## Multi-line input reminder

The CLI passes strings literally. `"...\n..."` sends a literal backslash-n. Use ANSI-C quoting for real newlines:

- `--plan $'1. A\n2. B'`
- `--append-notes $'Line 1\nLine 2'`
- `--final-summary $'Heading\n\nBody'`

POSIX-portable alternative: `--notes "$(printf 'Line 1\nLine 2')"`.

## Quick command reference

| Action | Command |
|--------|---------|
| View task | `backlog task <id> --plain` |
| List To Do | `backlog task list -s "To Do" --plain` |
| Set In Progress + assign | `backlog task edit <id> -s "In Progress" -a @myself` |
| Add plan | `backlog task edit <id> --plan "..."` |
| Append notes | `backlog task edit <id> --append-notes "..."` |
| Check AC | `backlog task edit <id> --check-ac <n>` |
| Check DoD | `backlog task edit <id> --check-dod <n>` |
| Add AC mid-flight | `backlog task edit <id> --ac "New requirement"` |
| Final summary | `backlog task edit <id> --final-summary "..."` |
| Mark Done | `backlog task edit <id> -s Done` |
| Search | `backlog search "topic" --plain` |
| Archive | `backlog task archive <id>` |

## Common issues

| Problem | Fix |
|---------|-----|
| Task not found | `backlog task list --plain` to find correct ID |
| AC won't check | `backlog task <id> --plain` to see current AC numbers |
| Metadata out of sync | Re-edit via CLI: `backlog task edit <id> -s <current-status>` |
