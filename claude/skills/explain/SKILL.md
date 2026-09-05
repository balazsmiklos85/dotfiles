---
name: explain
description: >
  Explains the rationale behind a recent action, code change, or decision.
  Covers why it was done, alternatives considered, trade-offs, risks reduced,
  and what to document for future reference. Use when the user asks to
  understand or justify a recent change, action, or decision.
---

# Skill: Explain

## Toolbox

When the user asks to understand a recent action or change, cover these dimensions:

- Why: the reasoning behind the decision
- Alternatives: what other options were considered and why they were rejected
- What this code does: a plain-language summary of the behavior
- Risks reduced: what problem or future pain point this addresses
- What we made harder: the trade-offs and added complexity
- What to write down: actionable notes to prevent forgetting

## Process

1. Identify the action or change to explain!
2. Walk through each dimension above, adapting to the context!
3. Highlight trade-offs honestly! What was gained and what was sacrificed?
4. Suggest concrete things to document, regardless if in comments, ADR, or docs, so the reasoning survives future context loss!

## Constraints

- The agent MUST NOT overexplain trivial changes! Match depth to significance!
- The agent SHOULD be honest about downsides. No decision is purely positive.
- The explanation SHOULD BE concise. The user wants understanding, not a lecture.
- If the change was reversible or low-stakes, the agent MAY say so explicitly.
