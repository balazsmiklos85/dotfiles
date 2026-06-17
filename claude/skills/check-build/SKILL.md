---
name: check-build
description: "Invoked whenever the agent runs any build, test, or static analysis command in a Gradle project. Follow this skill instead of running those commands directly!"
---

## Toolbox

`check_build` is a user specific script available on the global path. It runs `./gradlew` in the background, but it also
filters its output so only the relevant parts get to the output. Therefore there is no need to `grep` or `tail` its
output even more. The script takes no parameters, and does not write to stderr.

## How to call

- Just call `check_build` from Bash as it is!
- In case its output is not clear, ask the user how to investigate further.
