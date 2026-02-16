---
name: commit
description: Commits changes with a prefix
---

1. Fetch the current changes with `git diff main`
2. Commit your changes with the prefix "[!`git rev-parse --abbrev-ref HEAD | sd '^(\w+)[-_](\d+).*' '$1-$2'`] "
