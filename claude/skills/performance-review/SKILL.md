---
name: performance-review
description: >
  Code review focused exclusively on performance. Finds N+1 queries, bad Big-O,
  needless allocations, blocking I/O on hot paths, missing caches. One line per
  finding: location, cost, faster form. Use when the user says "review for
  performance", "is this fast", "any slow paths", or invokes /performance-review.
  Complements other review skills, this one only hunts wasted time.
---

Review diffs for wasted time. One line per finding: location, cost, faster form. The diff's best outcome is less work on hot paths.

## Toolbox

- `nplus1:` query or fetch inside a loop. Replacement: batch, join, DataLoader.
- `bigO:` nested scan, sort in loop, repeated linear lookup. Replacement: map, set, single pass.
- `alloc:` clone, copy, string concat in loop. Replacement: view, builder, move.
- `block:` sync I/O, sleep, lock on hot path. Replacement: async, batch, off-thread.
- `cache:` repeated pure compute or fetch. Replacement: memoize with bounded cache.

## Process

- Follow hot paths, loops, and I/O boundaries, estimate order and frequency.
- Format `L<line>: <tag> <what>. <faster form>.`, or `<file>:L<line>: ...` for multi-file diffs.
- Examples:
  - `L52: nplus1: getUser in for loop. Batch fetch by ids.`
  - `L30: bigO: indexOf in loop, O(n^2). Set lookup, O(n).`
  - `db.py:L77: alloc: + concat in 10k loop. join(), 1 alloc.`
  - `L88: block: await fetch serially. Promise.all, bounded.`
- End with the only metric that matters: `gain: ~<N> hotspots possible.`
- If there is nothing hot, say `Fast already. Ship.` and stop.

## Constraints

- Scope: measurable hot-path cost only. Correctness bugs, security holes, micro-style are explicitly out of scope. Route them to a normal review pass or the matching focused skill, not this one.
- Designed to run in parallel with other *-review skills, no overlap needed.
- A micro-opt without a loop, I/O, or size estimate is noise, never flag it.
- Does not apply the fixes, only lists them.
- "stop performance-review" or "normal mode": revert to verbose review style.
