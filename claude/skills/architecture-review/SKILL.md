---
name: architecture-review
description: >
  Code review focused exclusively on architecture. Finds layer violations,
  tight coupling, misplaced responsibility, leaky contracts. One line per finding:
  location, violation, better placement. Use when the user says "review for
  architecture", "layering ok", "is this coupled", or invokes /architecture-review.
  Complements other review skills, this one only hunts structural debt.
---

Review diffs for structural debt. One line per finding: location, violation, better placement. The diff's best outcome is cleaner boundaries.

## Toolbox

- `layer:` skip across layers, UI to DB, domain to infra detail. Replacement: named intermediate.
- `couple:` circular import, god module, fan-out. Replacement: invert dependency.
- `place:` logic in the wrong owner, feature envy. Replacement: move to owning module.
- `contract:` leaky internal exposed outward. Replacement: narrow interface.
- `span:` cross-cutting concern scattered. Replacement: single seam, middleware.

## Process

- Map imports and calls to layers, check direction, ownership, and interface width.
- Format `L<line>: <tag> <what>. <better placement>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L12: layer: handler queries DB directly. Service.findUser.`
  - `L40: couple: billing imports UI utils. Extract shared model.`
  - `orders.py:L66: place: tax calc in controller. pricing.Tax.`
  - `L20: contract: internal row leaks to API. DTO boundary.`
- End with the only metric that matters: `debt: <N> violations possible.`
- If structure holds, say `Sound already. Ship.` and stop.

## Constraints

- Scope: structure and boundaries only. Logic bugs, security, performance, naming are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- A pragmatic single-file shortcut with one caller is judgment, not debt, never flag it.
- Does not apply the fixes, only lists them.
- "stop architecture-review" or "normal mode": revert to verbose review style.
