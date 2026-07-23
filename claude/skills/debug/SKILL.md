---
name: debug
description: "Trigger when the user wants to debug or diagnose an issue, problem, or error!"
---

# Skill: Debug

## Toolbox

- Logs: Find the error message and stack trace! Ask the user if you don't have access to the logs!
- Recent changes: Check staged and unstaged changes, maybe even recent commits for code changes that could have caused the issue!
- Local reproduction: Have a failing test that shows this issue! Write one if none is available!
- Code inspection: Read the relevant code and configuration!
- Database: If the failure is data related, query the related data! Ask the user for data if you don't have access to
  the database!
- Validation: Make sure that tests are green after you applied your fix!
- Staging: Ask the user to confirm the fix by deploying into a staging environment and testing there manually!

## Process

*ALWAYS* follow this strict sequence for every debugging session:

1. State hypothesis *BEFORE* running any command or making any change! Clearly state your hypothesis about the root cause in one sentence!
2. Make the user agree with your hypothesis!
3. Verify! Run a targeted command or inspection to confirm or refute the hypothesis! Explain what you are looking for before running the command!
4. Conclude! Summarize what the evidence shows! If the hypothesis is disproven, state a new hypothesis and repeat!
5. Make the user agree with your conclusion!

## Constraints

- *NEVER* run commands without explaining what you are looking for!
- *NEVER* make edits before presenting your findings, and getting approval!
- *NEVER* dismiss a test failure! If a test fails, investigate the root cause and fix it! Do not skip, disable, or ignore it!
- *ALWAYS* make sure that the user agrees with you! Otherwise either your hypothesis / conclusion is wrong, or you leave the user in misunderstanding.
