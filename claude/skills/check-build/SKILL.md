---
name: check-build
description: "Use this skill to check the build state: compilation, tests, static code analysis."
---

## Toolbox

`check_build` is a user specific script available on the global path. It runs `./gradlew` in the background, but it also
filters its output so only the relevant parts get to the output. Therefore there is no need to `grep` or `tail` its
output even more.

## How to call

- Just call `check_build` from Bash.
- In case its output is not clear, ask the user how to investigate further.
