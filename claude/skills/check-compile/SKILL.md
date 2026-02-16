---
name: check-compile
description: Checks what the project compiles and fixes it if necessary
---

1. Check the build running `./gradlew compileJava compileTestJava --console=plain 2>&1 | rg -A 4 -B 1 'java:\d+: error'`
2. If the build fails, fix all compilation errors
