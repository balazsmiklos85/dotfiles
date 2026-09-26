---
name: maintainability-review
description: Code review focused on maintainability.
---

Review diffs for Clean Code readability. One line per finding: location, smell, cleaner shape. The diff's best outcome is easier to change.

## Toolbox

- `func:` does more than one thing, mixes abstraction levels, too long, deep nesting, switch on type. Replacement: extract till one thing per level.
- `args:` 3+ args, flag arg, out param. Replacement: param object or split.
- `comment:` redundant, misleading, commented-out code, excuse for unclear code. Replacement: expressive code, delete.
- `struct:` many responsibilities, low cohesion, train wreck, Demeter break. Replacement: split, delegate.
- `test:` hard-wired dependency, hidden I/O, clock, random, static. Replacement: inject seam.
- `dup:` G5 duplication, same branch or switch repeated. Replacement: single helper.

## Process

- Read as a future editor that is concerned with Clean Code and testability.
- Format `L<line>: <tag> <what>. <cleaner shape>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L10-80: func: 70-line handler, 4 levels. Split parse, validate, save.`
  - `L44: args: (user, force, verbose, out). Options object or split.`
  - `svc.py:L22: comment: // check if valid explains isValid(). Delete comment.`
  - `L15: struct: a.b().c().d() train. Delegate to owner.`
  - `L50: test: new Db() inside. Inject client seam.`
  - `L60-75: dup: same switch twice. Single map helper.`
- End with the only metric that matters: `drag: <N> spots possible.`
- If it reads clean, say `Maintainable already. Ship.` and stop.

## Constraints

- Scope: Clean Code change cost only. Meaningful Names go to naming-review, deletes to ponytail-review, logic bugs, security, performance, types are explicitly out of scope. Route them out, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- A single small duplication of 2-3 lines is cheaper to keep, never flag it.
- Does not apply the fixes, only lists them.
- "stop maintainability-review" or "normal mode": revert to verbose review style.
