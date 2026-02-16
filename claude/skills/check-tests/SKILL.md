---
name: check-tests
description: Checks that the tests are green and fixes them if necessary
allowed-tools: Bash(*)
---

1. Check the build running `./gradlew clean test --console=plain 2>&1 | rg -v '> Task|BUILD FAILED' | rg 'FAILED|See the report at'`
2. If integration tests fail to initialize the Spring context, check why that happens with `./gradlew test --console=plain 2>&1 | rg -v '( at |failure threshold|IT >|Test >)' | rg -v '^$' | rg -A 17 'ApplicationContext'`
3. If any tests fail
    a) Pick the first failing test
    b) Fix the test
    c) Commit your changes with the prefix "[!`git rev-parse --abbrev-ref HEAD | sd '^(\w+)[-_](\d+).*' '$1-$2'`] "
    d) GOTO a)
