---
name: rust
description: "Invoked when the agent is required to write or update any Rust code. Load and follow this skill before writing any Rust code!"
---

- *ALWAYS* write idiomatic Rust, following Rust API Guidelines and common conventions!
- *ALWAYS* use descriptive, meaningful domain-specific names for variables, methods, types, and modules! Prefer names from the problem domain over generic search idioms.
- Add `Clone` and `Copy` derives on thin enum variants and small structs for by-value semantics.
- Prefer borrowing (`&T`) over `.clone()`. Restructure lifetimes/ownership first, and only clone when ownership is genuinely required. Note: `Clone` on heap-allocated types (`Vec`, `String`, `HashMap`) has real cost — prefer borrowing or `Cow` when possible.
- *NEVER* add inline comments explaining *what* code does! If something needs explanation, rename, or extract a method to capture intent in the name. Exception: `unsafe` blocks *ALWAYS* get a `// SAFETY:` comment justifying the invariant being upheld.
- *ALWAYS* add `///` documentation comments to all public items (types, fields, methods, functions). Include `# Errors`, `# Panics`, and `# Examples` sections where applicable.
- Keep visibility minimal: `fn` (private) by default, `pub` only when a caller outside the module needs it.
- Group related functionality under `impl` blocks on a struct rather than free functions scattered across the module.
- Prefer iterator combinators (`map`, `filter`, `find`, `any`, `all`, `position`, `collect`) over imperative loops, unless the loop involves early-return error handling or multiple side effects, where an explicit `for` loop with `?` is clearer.
- Use `Result<T, E>` with meaningful error types over panics for recoverable errors. *NEVER* use `.unwrap()`/`.expect()` outside tests or examples.
- For library crates, prefer a custom error enum; for binaries/application code, prefer a dynamic error type over hand-rolled propagation.
- Implement `From`/`Into` for error conversions to enable ergonomic `?` usage. Implement `Display` and `Error` traits on custom error types.
- Favor readability over cleverness — explicit match arms are clearer than `if let` chains with many branches.
- After implementing or modifying code, run `cargo fmt`, then `cargo clippy` and fix all warnings before presenting results! Only use `#[allow(clippy::...)]` with a justified reason when fixing the lint would harm readability or is intentionally divergent.
- Make illegal states unrepresentable!
  - Prefer enums over structs with multiple fields that encode mutually exclusive states! For example, instead of:
    ```
    struct Invoice {
      paid: bool,
      receipt: Option<Receipt>,
      error: Option<String>,
    }
    ```
    use:
    ```
    enum Invoice {
      Pending,
      Paid(Receipt),
      Failed(Error),
    }
    ```
  - Prefer encoding business logic in types! For example instead of storing money as `amount: f64`, define your own types:
    ```
    enum Currency { Eur, Gbp, Huf }
    struct Money {
      minor_units: u64,
      currency: Currency,
    }
    ```
  - Prefer to encode states into the type system! For example, instead of having a `Connection` on which you need to check if it `is_open` before you can `send`, define it as a phantom type that can never be in an unexpected state:
    ```
    struct Connection<State> { /* ... */ }
    struct Open;
    struct Closed;

    impl Connection<Closed> {
      fn connect(self) -> Connection<Open> { /* ... */ }
    }

    impl Connection<Open> {
      fn send(&self, msg: &str) { /* ... */ }
    }
    ```
- Prefer `&str` over `&String` in function parameters — `&str` is more flexible and idiomatic.
- Use `impl AsRef<str>` when accepting string-like arguments that may be owned or borrowed.
- Use `Cow<'static, str>` for strings that are usually borrowed but may need to be owned in some cases.
- Prefer `.as_str()` or `.into()` over `.to_string()` where the target type is known.
- Avoid unnecessary `.to_owned()` on string literals — use `&str` directly when possible.
- Use `#[cfg(test)] mod tests` at the bottom of each source file for unit tests.
- Name test functions descriptively: `should_return_error_when_input_is_empty`, not `test1`.
- Use `assert_eq!` for equality checks, `assert!` for boolean conditions, and `assert_matches!` for pattern matching.
- Place integration tests under `tests/` at the crate root — one file per test module.
- Test both the happy path and error cases. Test edge cases: empty inputs, boundary values, `None`/`Some` transitions.
