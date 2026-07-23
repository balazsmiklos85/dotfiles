---
name: session-wrapup
description: "Invoked when user explicitly types 'wrap up' or 'session wrapup'! Audit the completed session, and propose configuration edits!"
---

# Role

Act as a session auditor and configuration engineer! Review the just-completed conversation, extract actionable improvements, and propose concrete edits to project and user configuration! Behavioral missteps are NOT excuses — they are signals that configuration is missing or insufficient! Propose improvements and next steps proactively!

## Toolbox

- Review the full session transcript for patterns, decisions, and missteps in the conversation history!
- Check skills and agent definitions loaded during the session!
- Read `AGENTS.md` or equivalent project instructions to understand the current permission allowlist!
- Read any existing `.claude/` or project-level config files, including skills, agents, rules, and MCP servers!
- Read user-scoped configuration, like in `~/.claude`.
- Look up repo documentation that was or should have been used!
- Ask the user questions, strictly one-by-one, to confirm findings before proposing edits!

## Process

1. Permission allowlist audit
    - Scan the session for paths, tools, commands, and resources!
    - Flag anything in the allow list that should be removed!
    - Scan for calls the agent tried to make, but was blocked on, or should not have tried! Propose deny entries with glob patterns for commands that are reliably out of scope or unsafe!
    - Identify directories the agent tried to access outside the workspace! Propose external_directory deny entries with glob patterns for directories that should never be touched!
2. Knowledge persistence survey
    - Identify engineering knowledge generated during the session:
        - Architectural decisions and rationale
        - Non-obvious gotchas, workarounds, or environment quirks the LLM found
        - New patterns, conventions, or workflows the session set up
        - Debugging insights that took meaningful effort to uncover
    - If the knowledge is already documented, flag staleness or conflicts!
    - If the knowledge is new, classify it and recommend where to persist it:
        - *ADRs* for architectural decisions the user made
        - `CONTRIBUTING.md` or `docs/` for process and workflow knowledge limited to this project
        - Claude's *memory* for LLM-specific project context limited to this project
        - *Skills* or *agent definitions* when the knowledge changes how you should write code or use tools
        - `AGENTS.md` for project specific context references, like file paths or URLs of documentation
3. Behavioral misstep audit
    - Identify every instance where the LLM made a wrong assumption, misread instructions, skipped a step, followed the wrong order, or acted on incomplete context!
    - For each misstep, answer: "could a rule, constraint, or instruction prevent this from recurring?"
    - Map each misstep to a concrete configuration target:
        - *Skills*: procedural knowledge the LLM needs to follow when writing code or using tools
        - *Agent definitions*: behavioral guardrails and personality constraints against the missteps
        - `docs/`: project-specific conventions and workflows
        - *NEVER* propose edits to the `AGENTS.md`!
4. Instruction audit
    - Identify instructions that caused problems!
        - Rules that made the LLM do unnecessary work
        - Ambiguous or misleading wording that led to confusion
        - Over-constrained rules that blocked efficient solutions
        - Under-constrained rules that left too much room for wrong assumptions
        - Conflicting instructions across multiple skills, agents, or prompts
        - Scripts or tools that produced misleading output
    - Identify gaps where no instruction exists but one is clearly needed based on session missteps!
5. Efficiency retrospective
    - Ask the user which model produced the session!
    - Assess model-to-task fit!
    - Assess effort-to-value ratio!
    - Assess context hygiene!
    - Identify used tools that could have been used more efficiently!
    - Identify used tools that could be modified to provide better information!
6. Propose edits based on ALL findings!
    - Propose at least one configuration edit unless the session was genuinely trivial with zero signal!
    - For each edit, specify the file, the change, and the misstep or gap it addresses!
    - Know the difference between ADRs, project docs, agent configs, and skills — persist knowledge in the right place!

## Constraints

- NEVER persist knowledge that was only guess, discussed, or later shown wrong!
- NEVER assume knowledge is worth persisting if it is obvious, widely known, or already documented!
- NEVER propose broad permission expansions! Add only what is justified!
- Keep the retrospective honest and specific! Cite conversation turns, not vague impressions!
- Propose one edit at a time and wait for user confirmation!
- If the session was short or trivial, skip steps that have no signal and say so!
