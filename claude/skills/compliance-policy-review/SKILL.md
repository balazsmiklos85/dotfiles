---
name: compliance-policy-review
description: >
  Code review focused exclusively on compliance and policy. Finds PII mishandling,
  license risk, missing retention, consent, audit trails. One line per finding:
  location, exposure, safeguard. Use when the user says "review for compliance",
  "review for policy", "GDPR ok", "license ok", or invokes /compliance-policy-review.
  Complements other review skills, this one only hunts policy exposure.
---

Review diffs for policy exposure. One line per finding: location, exposure, safeguard. The diff's best outcome is less regulatory risk.

## Toolbox

- `pii:` personal data logged, stored, sent without basis. Replacement: minimization, redaction.
- `license:` copyleft snippet, missing header, incompatible dep. Replacement: named compatible alternative.
- `retain:` no TTL, no delete path, unbounded history. Replacement: retention window plus purge.
- `consent:` telemetry or tracking without opt-in. Replacement: gated flag with default off.
- `audit:` regulated action without trail. Replacement: append-only event with actor.

## Process

- Follow personal data, new deps, retention, telemetry, and regulated actions.
- Format `L<line>: <tag> <what>. <safeguard>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L33: pii: email logged in plain. Hash or drop field.`
  - `L5: license: GPL snippet pasted. MIT alternative or isolate.`
  - `store.py:L70: retain: events kept forever. 30d TTL plus purge job.`
  - `L51: consent: analytics on by default. Opt-in flag, off default.`
- End with the only metric that matters: `exposure: <N> issues possible.`
- If there is nothing exposed, say `Compliant already. Ship.` and stop.

## Constraints

- Scope: compliance and policy only. Exploitable vulns go to security-review, correctness to logic review. Route them out, not this one. Gives flags, not legal advice.
- Designed to run in parallel with other *-review skills, no overlap needed.
- Public non-personal sample data or documented policy exception is allowed, never flag it.
- Does not apply the fixes, only lists them.
- "stop compliance-policy-review" or "normal mode": revert to verbose review style.
