---
name: global-replace
description: Invoke before changing the same pattern multiple times across one or more files: a global find-and-replace. Use instead of walking through files, reading them into context, and applying the same edits one by one.
---

# Global Replace

When a task requires changing the same pattern across files, **use `sd`** instead of reading files into context and editing them one by one!

## Basic usage

```
sd 'FIND' 'REPLACE' --glob='PATTERN'
```

## Key flags

- `-F`: Treat `FIND` and `REPLACE` as literal strings, not regex. Use *ONLY* when the `FIND` pattern has no variable parts, or `REPLACE` has no match groups to preserve!
- `--glob='PATTERN'`:  Restrict the replacement to files matching a glob `PATTERN`.
-  `-f`: Combined regex flags
    - `m` multi-line
    - `c` case-sensitive
    - `i` case-insensitive
    - `e` disable multi-line
    - `s` dot matches newlines
    - `w` full words only
- `-n <LIMIT>`: Cap the number of replacements per file. `0` means unlimited.
- `-p`: Preview changes in a human-readable format before applying.
- `-A`: Match across line boundaries. Uses more memory, prevents streaming.

## Examples

**Literal string replacement in all Rust files:**
```
sd -F 'old_literal' 'new_literal' --glob='*.rs'
```

**Case-insensitive regex replacement in TypeScript files:**
```
sd -f ci 'old\w+' 'newPattern' --glob='*.ts'
```

**Full-word match only:**
```
sd -f w 'oldWord' 'newWord' --glob='*.rb'
```

**Capture group, preserve part of the match:**
```
sd 'foo(\w+)' 'bar-$1' --glob='*.ts'
```

**Preview before applying:**
```
sd -p 'find' 'replace' --glob='**/*.js'
```

## When to use

- The same text or pattern needs to change in multiple files.
- You know the glob pattern of files to target, or it can be applied to every file.
- The change is mechanical, not contextual or file-specific.

## When NOT to use

- The replacement pattern differs per file, or depends on file-specific context.
- The change requires reading surrounding code to decide what to replace.
