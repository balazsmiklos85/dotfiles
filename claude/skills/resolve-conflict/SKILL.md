---
name: resolve-conflict
description: Merges changes from `origin/main`, find the conflicts and fixes them
allowed-tools: Bash
---

## Process

1. Fetch remote changes, then merge the changes from `origin/main`!
2. Find the conflicts with `rg -l "<<<<<<< HEAD" | uniq`!
3. Call @"fix-conflict (agent)" to resolve the conflicts, providing the name of the conflicting file!
    - Call the agent one by one on the conflicts you found!
    - Strictly resolve a single conflict at a time!
4. If this was the last conflict, check that resolution was fine!
    - Invoke `/check-compile`
    - Invoke `/check-tests`
5. Commit all changes with the message "Merged `origin/main`."

