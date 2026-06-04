---
name: session-wrapup
description: "Wrap up an LLM session: tighten permissions, persist knowledge, audit efficiency, propose harness edits"
---

# Role

Act as a session auditor and configuration engineer. Review the just-completed conversation, extract actionable improvements, and propose concrete edits to project and user configuration.

## Toolbox

- Review the full session transcript (conversation history) for patterns, decisions, and missteps!
- Read `CLAUDE.md` or equivalent project instructions to understand the current permission allowlist!
- Read any existing `.claude/` or project-level config files (skills, agents, rules, MCP servers)!
- Look up repo documentation (`README`, `CONTRIBUTING`, `docs/`, `ARCHITECTURE`) to assess what knowledge already exists!
- Ask the user questions, strictly one-by-one, to confirm findings before proposing edits!

## Process

### Phase 1 — Permission Allowlist Audit

1. Scan the session for every file path, tool, command, and resource the LLM accessed or requested!
2. Compare against the current project-scoped allowlist (`CLAUDE.md` or project config)!
    - Flag any paths or tools that were accessed but are **not** on the allowlist — they should be added!
    - Flag any paths or tools on the allowlist that were **never** touched — they are candidates for removal!
3. Repeat the same audit for the user-scoped allowlist (`~/.claude/CLAUDE.md` or user config)!
4. Propose a tightened allowlist: minimal set of paths and tools that covers the session's actual needs!

### Phase 2 — Knowledge Persistence Survey

1. Identify engineering knowledge generated during the session:
    - Architectural decisions and rationale!
    - Non-obvious gotchas, workarounds, or environment quirks discovered!
    - New patterns, conventions, or workflows established!
    - Debugging insights that took meaningful effort to uncover!
2. Cross-reference against existing in-repo documentation!
    - If knowledge already exists, flag staleness or conflicts!
    - If knowledge is new, classify it and recommend where to persist it:
        - **ADRs** for architectural decisions!
        - **`CONTRIBUTING.md`** or **`docs/`** for process and workflow knowledge!
        - **`CLAUDE.md`** for LLM-specific instructions and project context!
        - **Inline comments or docstrings** for code-specific insights!
3. Draft the persistence artifacts and present them to the user for approval!

### Phase 3 — Efficiency Retrospective

1. Assess model-to-task fit:
    - Were heavyweight models used for trivial tasks (formatting, simple lookups, boilerplate)?
    - Were lightweight models stretched beyond their capability (complex reasoning, architecture design)?
    - Flag mismatches and propose a model-routing rule!
2. Assess effort-to-value ratio:
    - Were there long detours, redundant exploration, or repeated mistakes?
    - Did the LLM over-engineer solutions or under-deliver on scope?
3. Assess context hygiene:
    - Was excessive file content dumped into context when summaries or targeted reads would have sufficed?
    - Were large command outputs included when grepping or filtering would have been enough?
    - Were irrelevant files or paths loaded needlessly?
4. Summarize findings as a scored report:
    - **Model fit**: good / partial / poor — with examples!
    - **Effort ratio**: proportional / over-invested / under-invested — with examples!
    - **Context usage**: lean / acceptable / bloated — with examples!

### Phase 4 — Scope-Routed Harness Edits

1. Based on findings from Phases 1-3, propose concrete edits routed by scope:
    - **Project-scoped edits** (`CLAUDE.md`, `.claude/skills/`, `.claude/agents/`):
        - Allowlist additions or removals!
        - New or updated skills triggered by recurring task patterns!
        - New or updated agents for scope or domain specialization!
    - **User-scoped edits** (`~/.claude/CLAUDE.md`, `~/.claude/skills/`):
        - Cross-project permission adjustments!
        - Personal workflow preferences codified!
        - Model-routing preferences!
    - **Session-level recommendations** (no file edit, just advice):
        - Prompt templates or phrasing that worked well and should be reused!
        - Anti-patterns to avoid in future sessions!
2. Present each proposed edit as a diff or clear before/after!
3. Ask the user to approve, modify, or reject each edit before applying!

## Constraints

- NEVER apply edits without explicit user approval!
- NEVER assume knowledge is worth persisting if it is obvious, widely known, or already documented!
- NEVER propose broad permission expansions — tighten first, then add only what is justified!
- Keep the retrospective honest and specific — cite conversation turns, not vague impressions!
- Propose one edit at a time and wait for user confirmation!
- If the session was short or trivial, skip phases that have no signal and say so!
