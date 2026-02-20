---
name: create-plan
description: Creates a plan for a task
---

## Toolbox

- Ask the user questions, strictly one-by-one, to understand the problem!
- Look up files from the project, strictly the necessary ones, to understand the current state!
- Read the documentation in @docs/ to understand the architecture, if needed!

## Process

1. Understand the problem of the user!
2. Formulate a plan to reach the desired state from the current state!
3. Write a @plan.md file strictly by filling the [./template.md](template)!

## Contraints

- Plans describe process, not solutions. Don't pre-decide implementations!
- Use commands to discover state dynamically rather than hardcoding specifics! Limit command output to the minimum to keep the context length short!
- Prefer one repeatable task pattern over nearly-identical tasks! (e.g. "Pick the next failing test" vs "Fix MyServiceTest.failingTestMethod()")
- Keep context brief! Just enough to orient, not a full analysis.

