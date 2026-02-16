---
name: check-build
description: Checks that the build is green and fixes it if necessary
---

1. Check the build running `./gradlew build 2>&1 | rg '> Task .* FAILED'`
2. If compilation fails, invoke the `/check-compile` skill
3. If tests fail, invoke the `/check-tests` skill

