---
name: rust
description: "Invoked when the agent is required to write or update any Rust code. Load and follow this skill before writing any Rust code!"
---

- *ALWAYS* write idiomatic Rust!
- *ALWAYS* add `Clone` on thin enum variants and small structs!
- *ALWAYS* add `Copy` derives when the type is conceptually a value!
- Prefer cheap borrowing, like `&T`, over costly `.clone()`! *NEVER* clone when ownership is not genuinely required!
- *NEVER* add inline comments explaining *what* code does! If something needs explanation, rename, or extract a method to capture intent in the name. Exception: `unsafe` blocks *ALWAYS* get a `// SAFETY:` comment justifying the invariant being upheld.
- *ALWAYS* add `///` documentation comments to all public items! Include `# Errors`, `# Panics`, and `# Examples` sections where applicable!
- *ALWAYS* keep visibility minimal! Use `pub` only when a caller outside the module needs it.
- *ALWAYS* group related functionality under `impl` blocks on a struct rather than free functions scattered across the module!
- *ALWAYS* use iterator combinators like `map`, `filter`, `find`, `any`, `all`, `position`, `collect` over imperative loops, unless the loop involves multiple side effects!
- *ALWAYS* use `Result<T, E>` with meaningful error types! *NEVER* panic!
- *NEVER* use `.unwrap()` outside tests or examples! *ONLY* use `.expect("reason")` when an invariant genuinely can't fail!
- *ALWAYS* use custom error enums for library crates! *ALWAYS* use dynamic error types for binaries/application code! *NEVER* use hand-rolled propagation!
- *ALWAYS* implement `From` for error conversions to enable ergonomic `?` usage! *ALWAYS* implement `Display` and `Error` traits on custom error types!
- *ALWAYS* favor readability over cleverness!
- *ALWAYS* use explicit match arms instead of deeply nested `if let` pyramids!
- *ALWAYS* check the results after modifying code! Run:
    - `cargo build` for compilation errors,
    - `cargo test` for test failures,
    - `cargo fmt --all` to format the code,
    - And `cargo clippy -- -Dclippy::pedantic` for static code analysis!
- *ALWAYS* Make illegal states unrepresentable!
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
- *NEVER* use `&String` in function parameters!
- *ALWAYS* use `impl AsRef<str>` when accepting string-like arguments that may be borrowed! *ALWAYS* use `impl
  Into<String>` when accepting string-like arguments that may be owned!
- *ALWAYS* use `Cow<'a, str>` for strings that are usually borrowed but may need to be owned in some cases!
- *NEVER* use `.to_string()` when the target type is known!
- *NEVER* use unnecessary `.to_owned()` on string literals!
- *ALWAYS* place integration tests under `tests/` at the crate root!
