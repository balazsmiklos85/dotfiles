---
name: adr
description: >
  Write Architecture Decision Records (ADRs). Dynamically picks the fitting
  format tier based on the decision's stakes and number of viable options:
  Y-statement for minor calls, Nygard as the everyday default, MADR for
  contested or high-stakes choices. Use when the user mentions "ADR",
  "architecture decision record", "decision record", asks to document an
  architectural or significant technical decision, or wants to supersede an
  existing one.
---

An architecture decision record (ADR) is a short document that captures one
important decision together with its context and consequences. Write each ADR
as a conversation with a future developer who no longer remembers why things
are the way they are.

## Toolbox

Three format tiers. Pick one per the Process section, then fill it in.

### Tier 1 — Y-statement (minor decisions)

```markdown
### <YYYY-MM-DD> — <short title>

In the context of <concern>, we decided <option> to achieve <quality goal>,
accepting the downside <negative consequence>.
```

### Tier 2 — Nygard (default)

```markdown
# <short noun phrase, e.g. "Use PostgreSQL for persistence">

## Status

<proposed | accepted | deprecated | superseded by [ADR-NNN](NNN-title.md)>

## Context

<Value-neutral description of the forces at play: technical, political,
social, project-local. Facts only, no arguing.>

## Decision

<The response to those forces. Full sentences, active voice: "We will ...".>

## Consequences

<What becomes easier or harder. List positive, negative, and neutral
consequences; they become the context of future ADRs.>
```

### Tier 3 — MADR (contested or high-stakes decisions)

```markdown
# <Short title of problem and solution>

* Status: <proposed | rejected | accepted | deprecated | superseded by [ADR-NNN](NNN-title.md)>
* Deciders: <names>
* Date: <YYYY-MM-DD>
* Confidence: <high | medium | low> <!-- optional -->

## Context and Problem Statement

<Two to three sentences, optionally phrased as a question.>

## Decision Drivers

* <force, concern, requirement driving the decision>

## Considered Options

* <option 1>
* <option 2>
* <option 3>

## Decision Outcome

Chosen option: "<option>", because <justification>.

### Positive Consequences

* <e.g. quality attribute gained, follow-up decisions required>

### Negative Consequences

* <e.g. quality attribute compromised, follow-up decisions required>

## Pros and Cons of the Options

### <option 1>

* Good, because <argument>
* Bad, because <argument>

### <option 2>

* Good, because <argument>
* Bad, because <argument>
```

Drop MADR sections that stay empty (Deciders, Drivers, Pros and Cons) rather
than padding them.

## Process

1. Assess the decision before writing anything:
   - Does it affect the system's structure, key quality attributes, or is it
     hard to reverse? If not, it may not need a record at all.
   - How many genuinely viable options exist?
   - What is the blast radius if it turns out wrong?
   - Is it easily reversible?
   - Are stakeholders likely to disagree or revisit the reasoning?
2. Select the tier:
   - Tier 1: one obvious option, low stakes, easily reversible, limited scope.
   - Tier 2: default when in doubt; a real choice was made but alternatives
     were few or quickly dismissed.
   - Tier 3: several plausible options, expensive or hard to reverse,
     contested among stakeholders, or long-term impact on structure,
     dependencies, interfaces, non-functional characteristics, or construction
     techniques.
3. Locate the ADR directory (`adr/`, `doc/adr/`, `docs/adr/`, `doc/arch/`,
   `decisions/`). If none exists, ask the user where to put it or propose
   `docs/adr/`. When adopting ADRs in an existing system, offer to backfill
   records for known past decisions while the knowledge is still available.
4. Take the next sequence number from existing files. Numbers are sequential
   and monotonic; never reuse them.
5. Name the file `<NNN>-<imperative-verb-phrase>.md`, lowercase with dashes,
   e.g. `0007-use-postgres-for-persistence.md`.
6. Write the record using the selected template. Aim for a single page; hard
   cap at two.
7. Set status to `proposed` until stakeholders agree, then `accepted`.
8. Record the confidence level when the call was made with low confidence,
   and note which context changes should trigger the team to reevaluate the
   decision.
9. When a decision unfolds in phases (short-, mid-, long-term), log each
    phase as its own record rather than one combined entry.
10. When a new decision replaces an old one: create the new ADR, then mark the
    old one `superseded by` with a link to its replacement. Otherwise leave old
    files untouched.

## Constraints

- One ADR documents exactly one decision, never several.
- Keep records pithy, assertive, on-topic, and factual.
- Write in inverted-pyramid style: the most important material first, details
  pushed to later sections.
- The record must stand alone. Link to supplemental design docs and
  discussions instead of embedding them; the decision stays clear without
  them.
- The Context section states facts neutrally; the Decision section argues in
  full sentences with active voice ("We will ...").
- Consequences list all of them — positive, negative, and neutral — not just
  the selling points. Never hide or soften a downside.
- Explain rationale: include why the alternatives lost, not just what won.
- Timestamp volatile facts (costs, pricing, schedules) with their date.
- Never alter the substance of an accepted ADR. Amend it with dated additions
  or supersede it with a new ADR.
- Skip the ADR entirely when the choice is trivial, temporary (workarounds,
  proofs of concept), or already covered by standards, policies, or existing
  documentation.
