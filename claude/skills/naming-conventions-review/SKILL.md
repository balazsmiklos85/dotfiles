---
name: naming-conventions-review
description: >
  Code review focused exclusively on naming conventions. Finds misleading,
  vague, cryptic, inconsistent names. One line per finding: location, bad name,
  better name. Use when the user says "review names", "naming ok", "is this clear",
  or invokes /naming-conventions-review. Complements other review skills, this one
  only hunts confusing names.
---

Review diffs for confusing names. One line per finding: location, bad name, better name. The diff's best outcome is names that read true.

## Toolbox

- `mislead:` name says X, code does Y. Replacement: verb true to behavior.
- `vague:` data, info, manager, util, helper. Replacement: concrete role noun.
- `abbr:` cryptic short, single letter outside loop. Replacement: full domain word.
- `inconsist:` different word for same concept, verb-noun mix. Replacement: codebase term.
- `case:` wrong casing or style-guide form. Replacement: guide form.

## Process

- Read exported names first, then locals, compare words to behavior and codebase terms.
- Format `L<line>: <tag> <what>. <better name>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L12: mislead: getUser creates user. createUser.`
  - `L28: vague: processData. validateCheckout.`
  - `db.py:L44: abbr: usrCfg. userConfig.`
  - `L60: inconsist: fetch vs get mixed. get* everywhere.`
- End with the only metric that matters: `renames: <N> possible.`
- If names read true, say `Named well already. Ship.` and stop.

## Constraints

- Scope: names only. Logic, structure, types are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- Ubiquitous domain terms and idiomatic loop indices like i, j, k are allowed, never flag them.
- Does not apply the fixes, only lists them.
- "stop naming-conventions-review" or "normal mode": revert to verbose review style.
