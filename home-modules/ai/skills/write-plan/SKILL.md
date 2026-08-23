---
name: planning
description: Create short implementation plans without restating prompts, instructions, preferences, or irrelevant context. Use when in planning mode, prior to writing the finalized plan.
---

# Planning

Create an implementation plan focused only on the work that needs to be done.

## Rules

* Do not restate or summarize the prompt.
* Do not quote or expose instructions, preferences, or context.
* Apply constraints silently unless they materially change the implementation.
* Do not explain how you are complying with instructions.
* Include only concrete engineering actions, important technical decisions, and validation steps.

Before including something, ask:

> Would removing this change the implementation or validation?

If not, omit it.

