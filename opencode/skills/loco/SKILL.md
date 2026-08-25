---
name: loco
description: "Expert guidance on Loco.rs, the Rails-inspired Rust web framework built on Axum and SeaORM: scaffolding and generators, models and migrations, controllers and routing, JWT and API-key auth, background workers and queues, tasks, scheduler, mailers, storage, cache, configuration, the cargo loco CLI, testing, and deployment. Use when a project depends on the loco-rs crate, src/app.rs implements Hooks, or the user mentions Loco."
---

# Loco Specialist v1.x

## Purpose

This skill provides expert guidance on Loco ("the one-person framework for Rust"): batteries-included Axum 0.8 + SeaORM 2.0. Everything compiles down to a real `axum::Router<AppContext>`; the framework pre-wires DB, auth, jobs, mail, storage, cache, config, and a CLI, each replaceable through documented seams (`Hooks`, `Initializer`, `SharedStore`).

## Toolbox

### Create an app

1. **Generate a new app** — supply all flags for a fully non-interactive run:
   ```sh
   loco new --name myapp --db sqlite --bg async --assets none
   ```
   - `--db`: `sqlite` | `postgres` | `none`
   - `--bg`: `async` | `queue-redis` | `queue-postgres` | `queue-sqlite` | `blocking`
   - `--assets`: `none` (JSON API) | `serverside` (Tera views) | `clientside` (React SPA in `frontend/`)
   - Any app with a database ships a complete auth suite at `/api/auth/*` (register, login, verify, forgot/reset, magic-link, current) automatically.

2. **Project layout**
   ```
   src/app.rs              # impl Hooks for App — wires routes, workers, tasks
   src/controllers/        # one file per resource
   src/models/_entities/   # GENERATED SeaORM entities — never edit
   src/models/<name>.rs    # your model logic (extension point)
   src/dtos/               # request/response types (ts-rs exports when SPA)
   src/workers/ src/tasks/ src/mailers/ src/fixtures/
   migration/src/          # one file per schema change
   config/<env>.yaml       # environment config
   assets/views/ assets/static/
   ```

3. **Built-in monitoring endpoints**: `/_ping`, `/_health`, `/_readiness` — mounted by `AppRoutes::with_default_routes()`.

### Generators

4. **Know the gate**: `cargo loco generate` (alias `g`) exists **only in debug builds**; `model`/`migration`/`scaffold` additionally need the `with-db` feature.

5. **Pick the right kind**
   ```sh
   cargo loco g scaffold posts title:string! content:text   # model+migration+DTOs+controller+routes+tests; JWT-protected by default (--no-auth for public)
   cargo loco g model comments content:text post:references # data layer only; applies migration + regenerates entities immediately
   cargo loco g controller comments list show               # JSON API controller, public by default (--auth to protect)
   cargo loco g migration AddViewsToPosts views:int         # see name inference below
   cargo loco g task cleanup_old_sessions
   cargo loco g worker send_digest
   cargo loco g mailer welcome
   cargo loco g scheduler                                   # writes config/scheduler.yaml
   cargo loco g data countries                              # data loader + data/<name>/data.json
   cargo loco g deployment docker                           # positional kind: docker | nginx | lambda
   cargo loco g override scaffold/api/controller.t          # copy built-in template to .loco-templates/ for editing
   ```
   - `scaffold` is adaptive: with a `frontend/` directory it also emits typed React Query hooks and pages.
   - Adding columns later: `cargo loco g migration AddViewsToPosts views:int` then `cargo loco db migrate && cargo loco db entities`.

6. **Field-type mini-language** (`field:type` pairs)
   - Suffixes: none = nullable `Option<T>`; `!` = required NOT NULL; `^` = unique (implies required).
   - `int` is **i64/BIGINT** (since 1.0; was i32). `big_int` is an alias; use `small_int` for 16-bit.
   - References: `user:references` (required FK `user_id`), `user:references?` (nullable), `award:references:prize_id` (custom column).
   - Enums: `status:enum:draft,published` — string column + real Rust enum in DTOs.
   - Arrays: `tags:array:string`, `scores:array!:int`.
   - Common types: `string`, `text`, `uuid`, `bool`, `float`, `double`, `decimal_len:8:24`, `date`, `time`, `date_time`, `tstz`, `json`, `jsonb`, `blob`, `money`.
   - Timestamps off: `--without-tz` (NOT `--without-timestamps`).

7. **Migration-name inference** (`generate migration <Name>`)
   | Name pattern | Operation |
   |---|---|
   | `Create<Table>` | create table |
   | `Add<Cols>To<Table>` | add columns |
   | `Remove<Cols>From<Table>` | remove columns |
   | `Rename<Old>To<New>On<Table>` | rename column |
   | `Add<Ref>RefTo<Table>` | add reference |
   | `CreateJoinTable<A>And<B>` | join table `<a>_<b>` |
   | anything else | Empty stub — `up()` is `todo!()` |

### Models and queries

8. **Query with the condition DSL**
   ```rust
   use loco_rs::prelude::*;

   let cond = query::condition()
       .contains(posts::Column::Title, "loco")
       .gt(posts::Column::Views, 10)
       .is_not_null(posts::Column::PublishedAt)
       .build();
   let published = posts::Entity::find().filter(cond).all(&ctx.db).await?;
   ```
   Operators: `eq`/`ne`, `gt`/`gte`/`lt`/`lte`, `between`/`not_between`, `like`/`not_like`, `starts_with`/`ends_with`/`contains`, `is_null`/`is_not_null`, `is_in`/`is_not_in`, `date_range`.

9. **Paginate**
   ```rust
   #[derive(Debug, Deserialize)]
   pub struct ListQueryParams {
       pub title: Option<String>,
       #[serde(flatten)]
       pub pagination: query::PaginationQuery, // ?page=2&page_size=10; page is 1-based
   }

   let res = query::paginate(&ctx.db, posts::Entity::find(), condition, &params.pagination).await?;
   format::json(res) // { "page": [...], "meta": { page, page_size, total_pages, total_items } }
   ```
   Use `query::fetch_page(&db, selector, &pagination)` when the selector already has `.filter()`/`.order_by()` applied. Typed envelope: `Page::from_query(res)` (flat `items` + meta fields).

10. **Relations**: `item.find_related(comments::Entity).all(&ctx.db).await?` loads a belongs-to/has-many side through the generated relation.

11. **Seed data**: fixtures are YAML lists under `src/fixtures/*.yaml`; wire `db::seed::<users::ActiveModel>(&ctx.db, &base.join("users.yaml")...)` into `Hooks::seed`; run `cargo loco db seed` (`--reset` to clear first, `--dump` / `--dump-tables users,posts` to export live tables back to YAML).

### Controllers and routing

12. **Handler shape**
    ```rust
    use loco_rs::prelude::*;

    pub async fn add(State(ctx): State<AppContext>, Json(params): Json<Params>) -> Result<Response> {
        let mut item = ActiveModel { ..Default::default() };
        params.update(&mut item);
        let item = item.insert(&ctx.db).await?;
        format::json(item)
    }

    pub fn routes() -> Routes {
        Routes::new()
            .prefix("api/posts/")
            .add("/", post(add))
            .add("{id}", get(get_one))
            .add("{id}/comments", get(comments_for_post)) // nested route
    }
    ```
    Register in `src/app.rs`: `AppRoutes::with_default_routes().add_route(controllers::posts::routes())`. The generator injects this automatically.

13. **Validate requests** with the validating extractors (derive `validator::Validate` on the params struct):
    - `JsonValidate<T>` / `FormValidate<T>` / `QueryValidate<T>` → plain `400 {"error":"Bad Request"}`
    - `JsonValidateWithMessage<T>` etc. → structured `{"errors": {"title": [{"code","message","params"}]}}`

14. **Prefixing and composition**: `Routes::prefix("notes")` scopes one controller; `AppRoutes::prefix("/api")` scopes controllers added after it; `nest_route("v1", routes)` adds a segment; `Routes::merge`/`nest` compose groups; `Routes::layer(tower_layer)` attaches middleware to one controller only.

### Authentication

15. **Protect a handler**
    ```rust
    pub async fn current(auth: auth::JWT, State(ctx): State<AppContext>) -> Result<Response> {
        let user = users::Model::find_by_pid(&ctx.db, &auth.claims.pid).await?;
        format::json(user)
    }
    ```
    - `auth::JWT` — validates token, gives claims; works without a DB. Invalid/missing/expired → extractor rejects with 401 before the handler runs.
    - `auth::JWTWithUser<users::Model>` — also loads the user row via `Authenticable::find_by_claims_key`; DB miss → 401, DB error → 500.
    - `auth::ApiToken<users::Model>` — API keys; reads **only** the `Authorization: Bearer <key>` header regardless of `auth.jwt.location`; no `auth.jwt` config needed.

16. **Configure JWT** (`config/<env>.yaml`)
    ```yaml
    auth:
      jwt:
        secret: "<%= get_env(name='JWT_SECRET') %>" # MUST be valid base64 (openssl rand -base64 64)
        expiration: 604800                          # seconds
        location: { from: Bearer }                  # or {from: Query, name: token} / {from: Cookie, name: auth_token}
                                                    # or a list of locations tried in order
    ```
    Default algorithm HS512 (code-level, not YAML). `auth::JWT` does not check email verification — check `user.email_verified_at.is_some()` yourself when needed.

17. **Mint a token**
    ```rust
    let jwt_config = ctx.config.get_jwt_config()?;
    let token = loco_rs::auth::jwt::JWT::new(&jwt_config.secret)
        .generate_token(jwt_config.expiration, user.pid.to_string(), serde_json::Map::new())
        .map_err(|e| Error::string(&e.to_string()))?;
    ```

18. **Passwords and tokens** (`loco_rs::hash`, always available):
    ```rust
    let hashed = hash::hash_password("plaintext")?;          // Argon2id, fresh salt
    if hash::verify_password(&submitted, &hashed) { /* bool, fails closed */ }
    let reset_token = hash::random_string(32);               // alphanumeric
    ```

### Background workers and queues

19. **Write a worker**
    ```rust
    #[derive(Deserialize, Debug, Serialize)]
    pub struct DownloadWorkerArgs { pub user_guid: String }

    pub struct DownloadWorker { pub ctx: AppContext }

    #[async_trait]
    impl BackgroundWorker<DownloadWorkerArgs> for DownloadWorker {
        fn build(ctx: &AppContext) -> Self { Self { ctx: ctx.clone() } }
        async fn perform(&self, args: DownloadWorkerArgs) -> Result<()> { Ok(()) }
    }
    ```
    Register in `Hooks::connect_workers`: `queue.register(DownloadWorker::build(ctx)).await?;` (the generator injects both).

20. **Enqueue**
    ```rust
    let job_id: String = DownloadWorker::perform_later(&ctx, args).await?; // returns job id
    DownloadWorker::perform_later_with_priority(&ctx, args, Some(100)).await?; // higher i32 = sooner
    ```

21. **Choose mode and backend** (`workers.mode`)
    | Mode | Queue backend? | Behavior |
    |---|---|---|
    | `BackgroundQueue` (default) | yes | durable; separate worker process |
    | `ForegroundBlocking` | no | inline, blocking — use in tests |
    | `BackgroundAsync` | no | `tokio::spawn` in-process; lost on crash |
    Backends via `queue.kind:` `Redis` (feature `worker_redis`) | `Postgres` | `Sqlite` (both covered by default `worker` feature). Same `perform_later` API everywhere; switching is config-only.

22. **Run and operate**
    ```sh
    cargo loco start --worker                # dedicated worker process (optionally --worker tag1,tag2)
    cargo loco start --server-and-worker
    cargo loco jobs cancel --name <NAME>     # also: tidy, purge --max-age 90, dump/import, requeue, retry --id
    ```
    `requeue` rescues stuck `processing` jobs; `retry` requeues `failed` ones — different tools. Opt-in automatic recovery: `queue.reaper: { age_minutes: 10, interval_seconds: 60 }`.

### Tasks and scheduler

23. **Write a task**
    ```rust
    pub struct UserCreate;
    #[async_trait]
    impl Task for UserCreate {
        fn task(&self) -> TaskInfo { TaskInfo { name: "user:create".to_string(), detail: "...".to_string() } }
        async fn run(&self, ctx: &AppContext, vars: &task::Vars) -> Result<()> {
            let email = vars.cli_arg("email").map_err(|_| Error::string("email is mandatory"))?;
            Ok(())
        }
    }
    ```
    ```sh
    cargo loco task                                    # list registered tasks
    cargo loco task user:create email:a@b.com name:"John"
    ```

24. **Schedule recurring jobs** — `scheduler:` block in env config or dedicated `config/scheduler.yaml`:
    ```yaml
    scheduler:
      output: stdout
      jobs:
        nightly_report:
          run: "posts_report"        # task name (shell: false) or shell command (shell: true)
          schedule: "at 10:00 am"    # English phrase OR 7-field cron (sec min hour dom mon dow year, UTC)
          run_on_start: true
          tags: ["reports"]
    ```
    Run: `cargo loco scheduler` (or `start --all`; set `SCHEDULER_CONFIG` for a dedicated file). Filter with `--name` / `--tag`.

### Mailers

25. **Send email** — mailers enqueue a `MailerWorker` job (priority 100 by default) and return immediately; a worker process must run for actual delivery.
    ```rust
    // src/mailers/auth.rs — template dir must contain exactly subject.t, html.t, text.t (Tera)
    static shared: Dir<'_> = include_dir!("src/mailers/shared");
    static welcome: Dir<'_> = include_dir!("src/mailers/auth/welcome");

    impl AuthMailer {
        pub async fn send_welcome(ctx: &AppContext, to: &str, msg: &str) -> Result<()> {
            Self::mail_template_with_shared(ctx, &welcome, &[&shared], mailer::Args {
                to: to.to_string(),
                locals: json!({ "message": msg, "domain": ctx.config.server.full_url() }),
                ..Default::default()
            }).await
        }
    }
    ```
    SMTP TLS: `tls: implicit` (port 465, required by providers that only accept SMTPS) overrides legacy `secure`; `starttls` for 587; `none` for local catchers. Dev/test without SMTP: `mailer: { stub: true }` (test.yaml already sets it).

### Storage

26. **Wire a driver** in `Hooks::after_context` — storage has NO YAML config:
    ```rust
    async fn after_context(ctx: AppContext) -> Result<AppContext> {
        let store = drivers::aws::new("my-bucket", "us-east-1")?; // feature storage_aws_s3
        Ok(ctx.into_builder().storage(storage::Storage::single(store).into()).build())
    }
    ```
    Drivers: `local::new()` (cwd-rooted), `mem::new()` (tests), `null::new()` (the silent default — every op errors), `aws`/`azure`/`gcp` behind `storage_*` features. Multi-store: `ReplicatedStrategy::mirror(primary, secondaries, FailurePolicy::FailIfAny)` or `::backup(...)`.

27. **Use it**
    ```rust
    ctx.storage.as_ref().upload(&path, &bytes).await?;
    let bytes: String = ctx.storage.as_ref().download(&path).await?;
    let stream = ctx.storage.download_stream(Path::new("videos/demo.mp4")).await?; // → axum Body
    ctx.storage.exists(&path).await?; ctx.storage.list(Path::new("uploads"), true).await?; ctx.storage.stat(&path).await?;
    ```

### Cache

28. **Configure in YAML** (`ctx.cache`, values serialized as JSON):
    ```yaml
    cache: { kind: InMem, max_capacity: 33554432 }            # default 32MiB; feature cache_inmem (on)
    cache: { kind: Redis, uri: "redis://...", max_size: 10 }  # feature cache_redis (off)
    ```
    Omitted `cache:` key = `Null` driver: `get()` returns `None`, mutations error.
    ```rust
    ctx.cache.insert_with_expiry("session:abc", &token, Duration::from_secs(300)).await?;
    let v = ctx.cache.get_or_insert::<Report, _>("report:daily", async { build(ctx).await }).await?;
    ```

### Configuration

29. **Loading rules**
    - File: `config/{env}.yaml` deep-merged with optional gitignored `config/{env}.local.yaml` (local wins key-by-key; scalars/lists replaced wholesale, never concatenated).
    - Environment: `LOCO_ENV` > `RAILS_ENV` > `NODE_ENV` > `"development"` — **the default is development**, so production must set `LOCO_ENV=production` explicitly.
    - Templating: `<%= get_env(name="PORT", default="5150") %>` renders before YAML parsing (YAML-safe delimiters; legacy `{{ }}` still works but deprecated).
    - Folder override: `LOCO_CONFIG_FOLDER`; inspect resolved result with `cargo loco doctor --config`.

30. **Required top-level keys**: `logger` (`enable`, `level`, `format`), `server` (`port`, `host`; `binding` defaults localhost), `database` (with-db: `uri`, pool sizes, timeouts). Optional: `queue`, `cache`, `auth`, `workers`, `mailer`, `initializers`, `settings`, `scheduler`.
    Database flags: `auto_migrate` (dev convenience), `dangerously_truncate` (test), `dangerously_recreate` — never outside dev/test. SQLite gets WAL + busy_timeout PRAGMAs automatically unless `run_on_start` is set.

31. **Production secrets** come from the environment with no fallback — missing variables stop boot with the variable's name: `DATABASE_URL`, `JWT_SECRET`, `HOST`, `MAILER_HOST`/`MAILER_USER`/`MAILER_PASSWORD`, `REDIS_URL`/`QUEUE_URL`. Multiple instances: set `DB_AUTO_MIGRATE=false`.

### Middleware

32. **13 built-ins** under `server.middlewares.<key>`. Defaults enabled when the key is absent: `limit_payload` (2mb, always), `catch_panic`, `etag`, `logger`, `request_id`, and `fallback` (non-production only). Disabled by default: `cors`, `remote_ip`, `compression`, `timeout_request`, `static`, `secure_headers`.
    Writing a middleware's key at all (even `etag: {}`) hands control to serde defaults where `enable` is `false` — always set `enable: true` explicitly.

33. **Ordering is LIFO**: middlewares listed last in the vec are outermost — the FIRST to see an inbound request. Edit the default stack with `MiddlewareStackExt` (in the prelude): `stack.delete("powered_by").insert_after("etag", Box::new(MyMiddleware));`

34. **Static files / SPA**
    ```yaml
    server:
      middlewares:
        fallback: { enable: false }        # disable the dev welcome screen shadowing assets
        static:
          enable: true
          folder: { uri: "/", path: "frontend/dist" }
          fallback: "frontend/dist/index.html"  # client-side routing survives hard refresh
    ```

### CLI cheat sheet

35. ```sh
    cargo loco start [-b ADDR] [-p PORT] [--worker[=tags]] [--server-and-worker] [--scheduler] [--all]
    cargo loco db create|migrate|down [steps]|reset|status|entities|truncate|seed|schema
    cargo loco routes                 # print every endpoint as a tree
    cargo loco middleware [--config]  # list stack + resolved configs
    cargo loco doctor [--config]      # env checks; non-zero exit on failure; CI-friendly
    cargo loco watch                  # wraps cargo-watch
    ```
    `generate` and `db entities` are debug-build-only. Binary name is `<app>-cli` in release builds.

### Testing

36. **Request tests** (`testing` feature + `serial_test` + `insta` with `redactions`):
    ```rust
    use loco_rs::testing::prelude::*;

    #[tokio::test]
    #[serial]
    async fn can_get_notes() {
        request::<App, _, _>(|request, _ctx| async move {
            let res = request.get("/api/notes/").await;
            assert_eq!(res.status_code(), 200);
        }).await;
    }
    ```
    Boots in `Environment::Test` (`config/test.yaml`), in-memory TestServer, no bound port. Cookies across calls: `request_with_config` with `RequestConfigBuilder::new().save_cookies(true)`.

37. **DB tests** — two strategies:
    - Shared DB: `config/test.yaml` with `dangerously_truncate: true`, `boot_test::<App>()` + `seed::<App>(&ctx)`, tests marked `#[serial]`.
    - Isolated: `boot_test_with_create_db::<App>()` creates a uniquely-named throwaway DB (Postgres) or temp-file SQLite, auto-cleaned on drop; no `#[serial]` needed for isolation.

38. **Snapshots** — redact dynamic fields so snapshots don't flap:
    ```rust
    with_settings!({ filters => cleanup_user_model() }, {
        assert_debug_snapshot!(res);
    });
    ```
    `cleanup_user_model()` redacts UUIDs/password hashes/timestamps/ids; `cleanup_email()` for mailer deliveries (`ctx.mailer.unwrap().deliveries()`). Update stale snapshots with `INSTA_UPDATE=always cargo test` (review the diff!) or `cargo insta review`. HTML: `assert_css_exists(&html, ".flash")`, `assert_css_eq(&html, "h1", "Welcome")`, `select(&html, ".item")`.

39. **Deterministic workers in tests**: set `workers.mode: ForegroundBlocking` in `config/test.yaml` so `perform_later` completes synchronously.

### Deployment

40. **Ship it**
    ```sh
    cargo build --release                       # produces target/release/<app>-cli
    cargo loco generate deployment docker       # or nginx | lambda (positional)
    scp target/release/myapp-cli config/ user@server:/opt/myapp/
    ssh user@server 'LOCO_ENV=production /opt/myapp/myapp-cli start'
    myapp-cli doctor --environment production   # before go-live
    ```
    Runtime needs only the binary + `config/`. Lambda entrypoint (`src/bin/lambda.rs`) is HTTP-only — run workers/scheduler elsewhere; prefer `--arm64`; consider RDS Proxy for Postgres connection pooling.

### Errors

41. **Status mapping** (`Error` → response): `NotFound` → 404; `Unauthorized` → 401 (message logged, not sent); `BadRequest` → 400; `Validation` → 400 with `{"errors": ...}`; `Model(EntityNotFound)` → 404; `Model(EntityAlreadyExists)` → 409; everything internal → 500. Helpers (in prelude): `unauthorized(msg)`, `bad_request(msg)`, `not_found()`. Constructors: `Error::string("...")`, `Error::msg(err)`, `Error::wrap(err)`, `.bt()` for opt-in backtraces.

### Hooks and AppContext

42. **Required `Hooks` methods** (no defaults): `app_name`, `boot` (delegate to `create_app::<Self, Migrator>(mode, environment, config)`), `routes`, `connect_workers`, `register_tasks`, plus `truncate`/`seed` with `with-db`. Useful overrides: `after_context` (rewrite the context — use `ctx.into_builder()`), `middlewares` (edit the default stack), `initializers`, `before_run`, `on_shutdown`, `init_logger` (return `Ok(true)` to own tracing yourself).

43. **`AppContext` fields**: `environment`, `db` (compiled out without `with-db`), `queue_provider`, `config`, `mailer`, `storage`, `cache`, `shared_store`. Derives `Clone, FromRef` — handlers may extract single fields (`State<DatabaseConnection>`). Custom services go in `shared_store` (TypeId-keyed DI): insert in `after_context`, read with the `SharedStore<T>` extractor (missing value → 500).

## Constraints

- Anything under `src/models/_entities/` MUST NOT be edited by hand — it MUST be regenerated with `cargo loco db entities`; model logic MUST live in `src/models/<name>.rs`.
- The `// inject-above (do not remove this comment)` anchor in `migration/src/lib.rs` MUST remain untouched — the generator injects migrations above it and fails loudly without it.
- Code MUST NOT rely on `cargo loco generate` in release builds — it is compiled out (`#[cfg(debug_assertions)]`).
- Skipping timestamp columns MUST be done with `--without-tz`; the `--without-timestamps` spelling MUST NOT be used — it no longer works.
- JWT secrets MUST be valid base64 — a plain passphrase fails at token time, not config-load time.
- `cache.kind: Null` MUST be written quoted (`"Null"`) — unquoted, YAML resolves it to null and deserialization fails.
- An app that uses storage or cache MUST wire a real driver (code in `after_context` / YAML respectively) — the defaults are fail-fast Null drivers whose every operation errors.
- When other data shares the cache's Redis instance, the cache MUST point at its own DB index — `cache.clear()` issues FLUSHDB and wipes the entire logical database.
- Code using `date_range` MUST account for its asymmetric boundaries: single-ended bounds are strict (`>` / `<`), double-ended is inclusive `BETWEEN`.
- Token location config MUST NOT be expected to affect `auth::ApiToken<T>` — it always reads the `Authorization: Bearer` header regardless of `auth.jwt.location`.
- Middleware ordering MUST be reasoned about as LIFO relative to the vec returned by `Hooks::middlewares` — the last entry is the first to see an inbound request.
- A migration whose name infers `Empty` has `todo!()` in `up()`; such stubs MUST be implemented before running `db migrate`, which panics otherwise.
- Pipelines that run `cargo loco start` against a static middleware configured with `must_exist: true` MUST build the frontend first (`pnpm build`) — the app refuses boot until the asset folder exists.
- App code MUST construct or modify `AppContext` through `ctx.into_builder()` — the struct is `#[non_exhaustive]`, struct literals do not compile, and rebuilding from scratch silently drops mailer/queue/cache/shared_store.
- Any exhaustive `match` on `loco_rs::Error` MUST include a `_ =>` wildcard arm — the enum is `#[non_exhaustive]`.
- Controller actions MUST NOT be named after HTTP methods (`get`, `post`, ...) — the prelude imports axum's routing functions, and shadowing them breaks the generated `routes()`.
- Secrets SHOULD be generated with `openssl rand -base64 64` and injected via `<%= get_env(...) %>` rather than hardcoded in YAML.
- Local development without an SMTP catcher on localhost:1025 SHOULD set `mailer.stub: true`; otherwise registration-style flows return 500.
- Whole-model snapshot tests fail on any schema change; snapshots SHOULD be re-accepted in the same commit as the migration.
- Queue backends, cache drivers, and middleware SHOULD be swapped via configuration rather than code — the APIs are identical across backends.
- New scaffolds use 64-bit (i64) keys; when mixing with pre-1.0 i32 tables, key types SHOULD be aligned (widen via migration or hand-edit) — the compiler flags mismatches, but planning for it avoids churn.
- An app without file-upload or object-storage needs MAY leave the default Null storage driver in place — its errors then indicate "not wired yet", not a bug.
- Low-stakes, best-effort background work MAY run with `workers.mode: BackgroundAsync` (no queue backend; jobs are lost on crash). Durable processing requires `BackgroundQueue` plus a configured `queue:` backend.
- DB tests MAY use either lifecycle strategy: one shared database truncated before each test (`dangerously_truncate: true` + `#[serial]`), or a unique throwaway database per test (`boot_test_with_create_db`, auto-cleaned on drop).
- Asset serving MAY differ per build profile — filesystem assets for fast development iteration, the `embedded_assets` feature for single-binary release builds.
- When porting from plain Axum, an existing router MAY be returned verbatim from `Hooks::before_routes`/`after_routes` — handlers and extractors keep working unchanged, at the cost of `cargo loco routes` visibility.
- Generator output MAY be customized by copying built-in templates into `.loco-templates/` with `cargo loco generate override <path>`; deleting the local copy reverts to the built-in template.
