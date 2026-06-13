---
name: create-plan
description: "Creates a TDD-driven plan for a task"
---

## Toolbox

- Ask the user questions, strictly one-by-one, to understand the problem!
- Look up files from the project, strictly the necessary ones, to understand the current state!
- Read the documentation in @docs/ to understand the architecture, if needed! Understand the architectural implications
  of your change!
- Identify scope boundaries of the change!
- For complex features, ask "what is the smallest testable behavior we can deliver first?" to break work into
  vertical slices rather than horizontal layers!
- Examine existing test structure to understand where new tests should live and what framework/conventions are used!

## Process

1. Understand the problem of the user!
2. Break the problem into small, testable vertical slices! Each slice should be small enough that its test can
   compile and run without days of implementation catching up!
3. For each slice, formulate the testable behavior first, then the minimal implementation!
4. Write a @plan.md file, **strictly** filling the template, replacing only the `[TODO: ...]` parts:

```
# [TODO: Title]

[TODO: very short description]

## Context

[TODO: the minimal amount of information to understand the nuances of the current state / the problem we are trying to solve / the architectural implications. Describe why we are here, not what to do.]

## Process

1. Take the first task from the list!
2. Complete the task and only that task!
3. Ask the user to check compilation errors, wait for the result! Fix anything that comes up!
4. Ask the user to check tests, wait for the result! Fix anything that comes up!
5. Look for non-extensive refactor opportunities! Offer any small improvements that you find!
6. Update `plan.md`!
7. Ask the user to commit the changes! Provide a one liner commit message!

## Tasks

- [ ] [TODO: task description]
    - [ ] [TODO: test details to verify the behavior]
    - [ ] [TODO: implementation details to make the test pass]
```

## Constraints

- Plans describe process, not solutions. Don't pre-decide implementations!
- Every task must be verifiable by a test! If a task can't be tested, break it down further!
- Prefer vertical slices over horizontal layers! A task should deliver observable behavior!
- Use commands to discover state dynamically rather than hardcoding specifics! Limit command output to the minimum
  to keep the context length short!
- Prefer one repeatable task pattern over nearly-identical tasks! For example "Pick the next failing test" vs
  "Fix MyServiceTest.failingTestMethod()".
- Keep context brief! Just enough to orient, not a full analysis.
- Preserve authors' original terminology and phrasing unless it's wrong! **Never** reword for the sake of sounding more technical or sophisticated!
- Preserve already completed work when changing plans!

