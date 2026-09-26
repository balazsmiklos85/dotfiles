---
name: security-review
description: >
  Code review focused exclusively on security. Finds injection, broken auth,
  secret exposure, weak crypto, unsafe deserialization. One line per finding:
  location, hole, fix. Use when the user says "review for security", "any vulns",
  "is this safe", or invokes /security-review. Complements other review skills,
  this one only hunts exploit paths.
---

Review diffs for exploit paths. One line per finding: location, hole, fix. The diff's best outcome is no trust boundary crossed unsafely.

## Toolbox

- `inject:` SQL, shell, XSS, path, template injection. Replacement: parameterized query, escaping, allowlist.
- `auth:` missing check, IDOR, privilege escalation, open endpoint. Replacement: enforce check at the seam.
- `secret:` hardcoded key, token in log, sensitive data in error. Replacement: vault, redaction.
- `crypto:` weak hash, predictable random, disabled TLS verify, ECB. Replacement: named strong primitive.
- `unsafe:` SSRF, XXE, open redirect, unsafe deserialize, tar slip. Replacement: allowlist, parser flag.

## Process

- Trace untrusted input to sink, check auth at each boundary, look for secrets and weak crypto.
- Format `L<line>: <tag> <what>. <fix>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L18: inject: f-string SQL. Parameterized query.`
  - `L44: auth: /admin lacks role check. Require admin middleware.`
  - `api.py:L92: secret: API key logged. Redact header.`
  - `L30: crypto: Math.random for token. crypto.randomBytes.`
- End with the only metric that matters: `risk: <N> holes possible.`
- If there is nothing exploitable, say `Secure already. Ship.` and stop.

## Constraints

- Scope: exploitable security only. Correctness bugs, performance, style are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- Suspicion without a source-to-sink path is noise, never flag it without the path.
- Does not apply the fixes, only lists them.
- "stop security-review" or "normal mode": revert to verbose review style.
