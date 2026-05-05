---
name: backlog-task-create
description: >
  Create well-formed tasks in a Backlog.md project via the `backlog` CLI. Covers
  Title, Description, Acceptance Criteria, labels/priority/assignee, references,
  documentation, and breakdown rules for atomic/independent tasks. Use when the
  user asks to create a backlog task, file a backlog ticket, break down work into
  backlog tasks, or add acceptance criteria at task-creation time. Do NOT use for
  editing existing tasks or implementing them — see `backlog-task-work` for that.
---

# Backlog.md — Creating Tasks

## Golden rule

**Never edit task files directly.** All task operations go through the `backlog` CLI. Direct edits to `backlog/tasks/*.md` break metadata, Git tracking, and relationships.

- Read tasks: `backlog task <id> --plain`
- List tasks: `backlog task list --plain`
- Search: `backlog search "topic" --plain`

Use `--plain` for AI-friendly text output.

## What goes in a task at creation time

**Only**: Title, Description, Acceptance Criteria, and optionally labels/priority/assignee/references/documentation.

**Do NOT** add an Implementation Plan, Implementation Notes, or Final Summary at creation time — those belong to the implementation phase (see `backlog-task-work`).

### Title — one liner

Clear, brief, summarizes the task.

### Description — the "why"

Concise summary of purpose and goal. Context, not implementation details.

### Acceptance Criteria — the "what"

Outcome-oriented, testable, unambiguous, user-focused.

Good:
- "User can successfully log in with valid credentials"
- "System processes 1000 requests per second without errors"

Bad (implementation steps, not outcomes):
- "Add a new function `handleLogin()` in auth.ts"
- "Define expected behavior and document supported input patterns"

## Creating a task

```bash
# Minimal
backlog task create "Title"

# With description and ACs
backlog task create "Title" -d "Description" --ac "First criterion" --ac "Second criterion"

# Full options
backlog task create "Title" \
  -d "Description" \
  -a @sara \
  -s "To Do" \
  -l backend,api \
  --priority high \
  --ac "User can do X" \
  --ac "System returns Y" \
  --ref src/api.ts \
  --ref https://github.com/org/repo/issues/123 \
  --doc docs/spec.md

# As a draft
backlog task create "Title" --draft

# As a subtask of task 42
backlog task create "Title" -p 42
```

### Multi-line input

The CLI preserves input literally — `"...\n..."` passes a literal `\n`, not a newline. Use ANSI-C quoting for real newlines:

```bash
backlog task create "Title" -d $'Line 1\nLine 2\n\nFinal paragraph'
```

## Task breakdown rules

When breaking a feature into multiple tasks:

1. **Foundations first** — create tasks in dependency order.
2. **Atomic** — each task is one PR's worth of work, independently verifiable.
3. **Independent** — tasks don't block each other.
4. **No forward references** — never reference future tasks (only `id < current id`).

## Definition of Done (per-task checklist)

Defaults come from `backlog/config.yml` → `definition_of_done`. To opt out at creation:

```bash
backlog task create "Feature" --no-dod-defaults
```

Add custom DoD items later with `backlog task edit <id> --dod "Run tests" --dod "Update docs"`.

## After creation

Hand off to the `backlog-task-work` skill when implementation begins. The implementer is responsible for setting status to In Progress, assigning, writing the plan, getting user approval on the plan, then coding.
