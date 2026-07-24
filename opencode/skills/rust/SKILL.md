---
name: rust
description: "Invoked when the agent is required to write or update any Rust code. Load and follow this skill before writing any Rust code!"
---

- *ALWAYS* write idiomatic Rust, following Rust API Guidelines and common conventions!
- *ALWAYS* use descriptive, meaningful domain-specific names for variables, methods, types, and modules! Prefer names from the problem domain over generic search idioms.
- Add `Clone` and `Copy` derives on thin enum variants and small structs for by-value semantics.
- Prefer borrowing (`&T`) over `.clone()`. Restructure lifetimes/ownership first, and only clone when ownership is genuinely required.
- *NEVER* add inline comments explaining *what* code does! If something needs explanation, rename or extract a method to capture intent in the name. Exception: `unsafe` blocks *ALWAYS* get a `// SAFETY:` comment justifying the invariant being upheld.
- *ALWAYS* add `///` documentation comments to all public items (types, fields, methods, functions).
- Keep visibility minimal: `fn` (private) by default, `pub` only when a caller outside the module needs it.
- Group related functionality under `impl` blocks on a struct rather than free functions scattered across the module.
- Prefer iterator combinators (`map`, `filter`, `find`, `collect`) over imperative loops, unless the loop involves early-return error handling or multiple side effects, where an explicit `for` loop with `?` is clearer.
- Use `Result<T, E>` with meaningful error types over panics for recoverable errors. *NEVER* use `.unwrap()`/`.expect()` outside tests or examples.
- For library crates, prefer a custom error enum (e.g. via `thiserror`); for binaries/application code, prefer a dynamic error type (e.g. via `anyhow`) over hand-rolled propagation.
- Favor readability over cleverness — explicit match arms are clearer than `if let` chains with many branches.
- After implementing or modifying code, run `cargo fmt`, then `cargo clippy` and fix all warnings before presenting results!
