---
name: logic-correctness-review
description: >
  Code review focused exclusively on logic and correctness. Finds wrong branches,
  off-by-one errors, missing edge cases, broken invariants. One line per finding:
  location, fault, correction. Use when the user says "review for logic",
  "review for correctness", "is this correct", or invokes /logic-correctness-review.
  Complements other review skills, this one only hunts wrong behavior.
---

Review diffs for wrong behavior. One line per finding: location, fault, correction. The diff's best outcome is being right.

## Toolbox

- `wrong:` branch does the opposite of the intent. Name the expected outcome.
- `edge:` missing empty, null, zero, single, boundary case. Name the case.
- `offby:` fencepost, inclusive versus exclusive, < versus <=. Show the bound.
- `invariant:` assumption that callers or state cannot hold. Name the violation.
- `missing:` check, guard, or handling that absence breaks. Name what is absent.

## Process

- Scan conditions, loops, state transitions, error paths for intent mismatch.
- Format `L<line>: <tag> <what>. <correction>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L22: wrong: retry on 4xx. Retry on 5xx and timeout only.`
  - `L41: edge: empty list unhandled. Early return [].`
  - `auth.py:L88: offby: range(len(x)) skips last. range(len(x)+1) or <=.`
  - `L52: invariant: assumes user exists after delete. Re-fetch or guard.`
- End with the only metric that matters: `correct: <N> faults possible.`
- If there is nothing wrong, say `Correct already. Ship.` and stop.

## Constraints

- Scope: logic and correctness only. Security holes, performance, style, naming, types are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- A single clarifying comment or truth-table note is the correctness minimum, not noise, never flag it.
- Does not apply the fixes, only lists them.
- "stop logic-correctness-review" or "normal mode": revert to verbose review style.
