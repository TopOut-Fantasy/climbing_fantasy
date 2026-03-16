# Agent State

This directory is the shared home for durable agent guidance in this repository.

## Structure

```
.agents/
  README.md          # this file
  lessons.md         # cross-agent lessons from user corrections
  plans/
    <feature>/       # one folder per feature (e.g., fantasy-draft-mvp, auth)
      plan.md        # high-level design (architecture, data model, decisions)
      todo.md        # implementation checklist with checkable items
```

## Rules

- Use `.agents/lessons.md` for cross-agent lessons learned from user corrections.
- Each feature gets its own folder under `.agents/plans/` with `plan.md` (design) and `todo.md` (checklist).
- Keep entries concise and durable so different agents can reuse them.
