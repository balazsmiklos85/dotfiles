---
name: api-compatibility-review
description: >
  Code review focused exclusively on API compatibility. Finds breaking schema,
  renamed fields, changed defaults, missing deprecation or version bumps. One line
  per finding: location, break, compatible path. Use when the user says "review
  for API compat", "is this breaking", "contract ok", or invokes
  /api-compatibility-review. Complements other review skills, this one only hunts
  client breaks.
---

Review diffs for client breaks. One line per finding: location, break, compatible path. The diff's best outcome is old clients still working.

## Toolbox

- `break:` removed or renamed field, narrowed type, new required. Replacement: optional plus fallback.
- `default:` changed default or semantic of existing value. Replacement: preserve old, flag-gate new.
- `contract:` OpenAPI or schema drift, status code shape change. Replacement: sync spec plus version bump.
- `deprec:` removal without sunset window. Replacement: deprecate header plus window.
- `client:` pagination, error, auth flow change for callers. Replacement: additive change only.

## Process

- Diff public surface, schemas, defaults, errors, versions against prior contract.
- Format `L<line>: <tag> <what>. <compatible path>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L20: break: id int to string. Keep int, add idStr.`
  - `L35: default: limit 20 to 50. Keep 20, opt-in 50.`
  - `openapi.yaml:L88: contract: 200 shape changed. v2 route plus spec bump.`
  - `L60: deprec: field removed outright. Sunset header, 30d.`
- End with the only metric that matters: `breaks: <N> possible.`
- If clients are safe, say `Compatible already. Ship.` and stop.

## Constraints

- Scope: public contract only. Internal refactors with no external effect are explicitly out of scope, never flag them.
- Designed to run in parallel with other *-review skills, no overlap needed.
- Explicitly versioned experimental or v0 unstable surface is exempt, never flag it.
- Does not apply the fixes, only lists them.
- "stop api-compatibility-review" or "normal mode": revert to verbose review style.
