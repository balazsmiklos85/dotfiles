---
name: type-safety-design-review
description: >
  Code review focused exclusively on type safety and design. Finds any escapes,
  unsafe casts, null leaks, stringly types, states that allow invalid values. One
  line per finding: location, hole, tighter type. Use when the user says "review
  types", "type safety ok", "is this sound", or invokes /type-safety-design-review.
  Complements other review skills, this one only hunts type holes.
---

Review diffs for type holes. One line per finding: location, hole, tighter type. The diff's best outcome is invalid states unrepresentable.

## Toolbox

- `any:` any, unknown, object escape. Replacement: concrete union or generic.
- `cast:` as, satisfies bypass, non-null bang without narrow. Replacement: narrow with guard.
- `null:` nullable flows without handling. Replacement: Option, early return, default.
- `narrow:` stringly type, bool pair, missing discriminated union. Replacement: literal union or enum.
- `design:` primitive obsession, type allows invalid combo. Replacement: branded type, split variant.

## Process

- Follow public signatures inward, distrust casts and nullables, check impossible states.
- Format `L<line>: <tag> <what>. <tighter type>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L14: any: payload: any. UserPayload union.`
  - `L29: cast: x as Admin without check. isAdmin(x) guard.`
  - `user.ts:L51: null: email? used raw. Early return or default.`
  - `L70: narrow: status: string. "active" | "archived".`
- End with the only metric that matters: `unsafe: <N> spots possible.`
- If types hold, say `Typed well already. Ship.` and stop.

## Constraints

- Scope: type soundness only. Runtime logic bugs not caused by types, performance, naming are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- Generated code and test doubles with isolated any are allowed, never flag them.
- Does not apply the fixes, only lists them.
- "stop type-safety-design-review" or "normal mode": revert to verbose review style.
