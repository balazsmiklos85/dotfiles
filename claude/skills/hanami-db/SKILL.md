---
name: hanami-db
description: "Expert guidance on Hanami DB: configuration, relations, queries, joins, combines, migrations, transactions, commands, changesets, repositories, and structs"
---

# Hanami DB Specialist v2.x

## Purpose

This skill provides expert guidance on Hanami's persistence layer built on ROM (Ruby Object Mapper). It covers database configuration, relations (schemas, associations, querying, joins, combines, datasets, scopes), migrations, transactions, commands, changesets (validation, mapping, associations), repositories, and structs.

## Toolbox

### Database Configuration

1. **Create a new app with a database**
   ```console
   hanami new bookshelf --database=sqlite  # default
   hanami new bookshelf --database=postgres
   hanami new bookshelf --database=mysql
   hanami new bookshelf --skip-db         # no DB layer
   ```

2. **Configure DATABASE_URL**
   ```
   # .env (development)
   DATABASE_URL=sqlite://config/db/development.sqlite
   DATABASE_URL=postgres://localhost/bookshelf_development
   DATABASE_URL=mysql2://user:password@localhost/bookshelf_dev
   ```
   - Test database URL is auto-derived by appending `_test` to the development name
   - For MySQL: use `mysql2://` prefix

3. **Configure slice-specific databases**
   ```
   # For a slice named `admin`
   MAIN__DATABASE_URL=sqlite://slices/main/config/db/development.sqlite
   ```
   - Use `SLICE_NAME__DATABASE_URL` convention
   - Slice DB config lives in `slices/<name>/config/db`

4. **Add advanced configuration via providers**
   ```ruby
   # config/providers/db.rb (app-level)
   # or slices/<name>/config/providers/db.rb (slice-level)
   Hanami.app.configure_provider :db do
     config.gateway :default do |gw|
       gw.database_url = "postgres://localhost:5432/mydb"

       gw.adapter :sql do |sql|
         # ROM plugins
         sql.plugin relations: :auto_restrictions

         # Sequel extensions
         sql.extension :caller_logging, :error_sql, :sql_comments
         sql.extension :pg_array, :pg_enum, :pg_json, :pg_range
       end
     end
   end
   ```

5. **Skip defaults when needed**
   ```ruby
   gw.adapter :sql do |sql|
     sql.skip_defaults              # skip everything
     sql.skip_defaults :plugins     # skip ROM plugins only
     sql.skip_defaults :extensions  # skip Sequel extensions only
   end
   ```

6. **Configure multiple gateways**
   ```
   DATABASE_URL=postgres://localhost:5432/bookshelf_development
   DATABASE_URL__LEGACY=mysql://localhost:3306/legacy
   ```
   ```ruby
   # In a relation
   class LegacyUsers < Hanami::DB::Relation
     gateway :legacy
     schema infer: true
   end
   ```

7. **Set connection options**
   ```ruby
   Hanami.app.configure_provider :db do
     config.gateway :default do |gw|
       gw.connection_options search_path: ['public', 'alt']
     end

     config.gateway :legacy do |gw|
       gw.connection_options max_connections: 4
       gw.adapter :sql
     end
   end
   ```

8. **Access DB via container keys**
   - `db.config` — Final ROM configuration object
   - `db.rom` — ROM instance for the slice
   - `db.gateway` — Default DB gateway
   - `db.gateways.default` — Explicitly-named gateway
   - `db.gateways.<name>` — Any additional gateway

### Relations

9. **Define a basic relation**
   ```ruby
   # app/relations/books.rb
   module Bookshelf
     module Relations
       class Books < Hanami::DB::Relation
         schema :books, infer: true
       end
     end
   end
   ```
   - Relations are **plural** (model a collection)
   - Located in `app/relations/` or `slices/<name>/relations/`
   - Registered under the `relations` namespace (e.g., `relations.books`)

10. **Customize schema with type coercion**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true do
        primary_key :id
        attribute :status, Types::String, read: Types::Coercible::Symbol
      end
    end
    ```
    - `read:` type is used when reading from DB
    - Default type (first arg) is used when writing to DB
    - Types come from `ROM::SQL::Types` (built on dry-types)

11. **Define custom types for complex data**
    ```ruby
    class Credentials < Hanami::DB::Relation
      JWKS = Types.define(JWT::JWK::Set) do
        input { |jwks| Types::PG::JSONB[jwks.export] }
        output { |jsonb| JWT::JWK::Set.new(jsonb.to_h) }
      end

      schema infer: true do
        attribute :jwks, JWKS
      end
    end
    ```

12. **Define one-to-many associations**
    ```ruby
    class Publishers < Hanami::DB::Relation
      schema :publishers, infer: true do
        associations do
          has_many :books
        end
      end
    end
    ```
    - `has_many` is aliased as `one_to_many`

13. **Define many-to-one associations**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true do
        associations do
          belongs_to :language
        end
      end
    end

    class Languages < Hanami::DB::Relation
      schema :languages, infer: true do
        associations do
          has_many :books
        end
      end
    end
    ```
    - `belongs_to` is a shortcut for `many_to_one :languages, as: :language`

14. **Define many-to-many associations through a join table**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true do
        associations do
          has_many :authors, through: :authorships
        end
      end
    end

    class Authorships < Hanami::DB::Relation
      schema :authorships do
        primary_key :id
        attribute :book_id, Types.ForeignKey(:books)
        attribute :author_id, Types.ForeignKey(:authors)
        attribute :order, Types::Integer

        associations do
          belongs_to :book
          belongs_to :author
        end
      end
    end

    class Authors < Hanami::DB::Relation
      schema :authors, infer: true do
        has_many :books, through: :authorships
      end
    end
    ```

15. **Use custom foreign keys**
    ```ruby
    class Credentials < Hanami::DB::Relation
      schema :credentials, infer: true do
        attribute :user_id, Types.ForeignKey(:users, Types::PG::UUID)
      end
    end
    ```

16. **Alias relations**
    ```ruby
    class Authorships < Hanami::DB::Relation
      schema :books_authors, infer: true, as: :authorships
    end

    class Books < Hanami::DB::Relation
      schema :books, infer: true do
        associations do
          has_many :books_authors, as: :authorships, relation: :authorships
        end
      end
    end
    ```

### Querying

17. **Query with hash-based syntax**
    ```ruby
    books.where(publication_date: Date.new(2024, 11, 5))
    books.where(id: 1).one
    books.where(title: "Hanami").to_a
    books.exclude(pages: ...1000)
    books.fetch(1)  # shortcut for where(id: 1).one
    ```

18. **Query with expression-based syntax** (Sequel VirtualRows)
    ```ruby
    books.where { publication_date.is(Date.new(2024, 11, 5)) }
    books.where { date_part('year', publication_date) > 2020 }
    books.exclude { pages < 1000 }
    ```

19. **Select specific columns**
    ```ruby
    books.select(:id, :title).first
    books.select { [id, title] }.first
    # => { id: 1, title: "To Kill a Mockingbird" }

    books.select(:id, :title).select_append(:pages).first
    ```
    - Multiple `select` calls replace the existing projection
    - Use `select_append` to add columns

20. **Order results**
    ```ruby
    books.order(:title)
    books.order { [publication_date.desc, title.asc] }
    books.unordered  # remove ordering
    ```

21. **Use dynamic typed columns**
    ```ruby
    books.select {[
      integer::count(:id).as(:total),
      integer::count(:id).filter(pages < 300).as(:short),
      integer::count(:id).filter(pages > 300).as(:long)
    ]}.unordered.one
    # => { total: 2, short: 1, long: 1 }
    ```
    - Available type prefixes: `bool`, `date`, `datetime`, `decimal`, `float`, `hash`, `integer`, `json`, `range`, `serial`, `string`, `time`

22. **Use case expressions**
    ```ruby
    books.select {[
      id,
      title,
      string::case(
        quantity.is(0) => "out-of-stock",
        (quantity < 100) => "low-stock",
        else: "in-stock"
      ).as(:status)
    ]}.to_a
    ```

23. **Inspect generated SQL**
    ```ruby
    books.dataset.sql
    ```

### Joins

24. **Join relations at the SQL level**
    ```ruby
    class Users < Hanami::DB::Relation
      schema :users, infer: true do
        associations do
          has_many :tasks
          has_many :posts
        end
      end

      def with_tasks
        join(tasks)
      end

      def with_posts
        left_join(posts)
      end
    end

    users.with_tasks.to_a       # INNER JOIN
    users.with_posts.to_a       # LEFT JOIN
    ```

25. **Join with explicit options**
    ```ruby
    class Users < Hanami::DB::Relation
      schema :users, infer: true do
        associations do
          has_many :tasks
        end
      end

      def with_tasks
        join(:tasks, { id: :user_id }, table_alias: :user_tasks)
      end
    end
    ```

26. **Use `right_join` when needed**
    ```ruby
    users.right_join(posts)
    ```

### Combines

27. **Combine relations to load nested data**
    ```ruby
    # Load a user with their projects (lazy loading — no N+1)
    users.by_id(2).combine(:projects).one
    # => {:id=>2, :username=>"john", :projects=>[{:id=>1, :user_id=>2, :name=>"Project A"}]}

    # ROM never loads associated data unless explicitly combined
    users.by_id(2).one
    # => {:id=>2, :username=>"john"}  (no :projects key)
    ```

28. **Nested combine**
    ```ruby
    users.by_id(2).combine(projects: :project_tasks).one

    # Complex nesting
    users.by_id(2).combine(
      projects: [{ project_tasks: :reviewed_by }, :reviewed_by]
    ).one
    ```

29. **Adjust nested data with `node`**
    ```ruby
    users.by_id(2)
      .combine(projects: :project_tasks)
      .node(projects: :project_tasks) { |tasks_rel|
        tasks_rel.where { description == 'Task 1' }
      }
      .one
    ```
    - `node` must come **after** `combine` in the call chain
    - Use `node` with `select` to limit columns in nested relations

### Dataset and Scopes

24. **Set default dataset**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true

      dataset do
        select(:id, :title, :publication_date).order(:publication_date)
      end
    end
    ```

25. **Simulate soft deletes with dataset**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true
      dataset { where(archived_at: nil) }
    end

    # Bypass default filter
    books.unfiltered.exclude(archived_at: nil)
    ```

26. **Define custom scopes**
    ```ruby
    class Books < Hanami::DB::Relation
      schema :books, infer: true

      def recent
        where { publication_date > Date.new(2020, 1, 1) }
      end
    end

    books.recent
    ```
    - Scopes are chainable (return a new Relation)
    - Every relation with a primary key gets `by_pk` automatically
    - Query-terminating methods: `one`, `to_a`, `each`

### Migrations

27. **Generate migrations via CLI**
    ```console
    hanami db new create_users
    hanami db new create_posts
    hanami db migrate          # run pending migrations
    hanami db rollback         # undo last migration
    hanami db seed             # run seed files
    ```

28. **Write a basic migration** (auto-inferable down)
    ```ruby
    ROM::SQL.migration do
      change do
        create_table :users do
          primary_key :id
          foreign_key :account_id, :accounts, on_delete: :cascade, null: false

          column :given_name, String, null: false
          column :family_name, String, null: false
          column :email, "citext", null: false
        end
      end
    end
    ```

29. **Write migration with explicit up/down**
    ```ruby
    ROM::SQL.migration do
      up do
        alter_table :users do
          add_unique_constraint [:email], name: :users_email_uniq
        end
      end

      down do
        alter_table :users do
          drop_constraint :users_email_uniq
        end
      end
    end
    ```

30. **Run migration outside a transaction**
    ```ruby
    ROM::SQL.migration do
      no_transaction

      up do
        alter_table :users do
          add_index :email, concurrently: true
        end
      end

      down do
        alter_table :users do
          drop_index :email, concurrently: true
        end
      end
    end
    ```

31. **Use raw SQL as an escape hatch**
    ```ruby
    ROM::SQL.migration do
      up do
        execute <<~SQL
          CREATE TRIGGER posts_tsvector_update()
          BEFORE INSERT OR UPDATE ON public.posts
          FOR EACH ROW
          WHEN (
            OLD.title IS DISTINCT FROM NEW.title OR
            OLD.content IS DISTINCT FROM NEW.content
          )
          EXECUTE PROCEDURE tsvector_update_trigger(search_tsvector, 'public.english', title, content)
        SQL
      end

      down do
        execute "DROP TRIGGER posts_tsvector_update() ON public.posts"
      end
    end
    ```
    - Raw SQL requires explicit up/down (cannot infer reverse)

32. **Column type options in migrations**
    ```ruby
    create_table :users do
      # Explicit SQL type
      column :email, "varchar(255)", null: false

      # Ruby type (inferred SQL)
      column :email, String, null: false

      # Helper method (no inference, SQL type: text)
      text :email, null: false

      # Ruby type method (inferred SQL)
      String :email, null: false
    end
    ```

33. **Define constraints in migrations**
    ```ruby
    create_table :users do
      primary_key :id
      column :name, String, null: false
      constraint(:name_min_length) { char_length(name) > 2 }
    end
    ```

34. **Use structure.sql for database schema snapshots**
    - Located at `config/db/structure.sql`
    - Reflects current DB structure state
    - Useful for blank-slate database setup

### Transactions

35. **Wrap writes in a transaction**
    ```ruby
    # Automatic rollback on error
    users.transaction do |txn|
      users.command(:create).call(name: "Jane")
      tasks.command(:create).call(title: "Task 1", user_id: 1)
    end

    # Manual rollback
    users.transaction do |txn|
      users.command(:create).call(name: "Jane")
      txn.rollback!  # everything rolled back
    end
    ```
    - Use via any relation: `relation.transaction { ... }`
    - Exceptions trigger automatic rollback
    - Changesets also support transaction via `changeset.transaction`

### Repositories

36. **Define a repository**
    ```ruby
    class UserRepo < Hanami::DB::Repo
      def find(email)
        users.where(email:).one
      end
    end
    ```
    - Inherits from `Hanami::DB::Repo`
    - Relations are available as methods (e.g., `users`)
    - Encapsulates persistence layer details from business logic

37. **Repository provides a stable API**
    ```ruby
    # Before: emails as identity
    class UserRepo < Hanami::DB::Repo
      def find(email)
        users.where(email:).one
      end
    end

    # After: usernames as identity — only this file changes
    class UserRepo < Hanami::DB::Repo
      def find(username)
        users.where(username:).one
      end
    end
    ```

### Commands

38. **Use commands for direct write operations**
    ```ruby
    # Create
    users.command(:create).call(name: "Jane", email: "jane@example.com")

    # Create multiple at once
    create = users.command(:create, result: :many)
    create.call([
      { name: "Jane", email: "jane@example.com" },
      { name: "John", email: "john@example.com" }
    ])

    # Update
    users.by_pk(1).command(:update).call(name: "Jane Doe")

    # Delete
    users.by_pk(1).command(:delete).call
    ```
    - `command(:create)`, `command(:update)`, `command(:delete)`
    - Lower-level than changesets — faster for bulk operations (~1.5–2x)
    - `result: :many` enables batch inserts

39. **Persist nested data with combined commands**
    ```ruby
    # Persist a user with associated tasks in one call
    users.combine(:tasks).command(:create).call(
      name: "Jane",
      email: "jane@example.com",
      tasks: [
        { title: "Task 1" },
        { title: "Task 2" }
      ]
    )
    ```
    - Requires associations to be defined in both relations' schemas
    - Limited to `:create` commands only
    - For `:update`/`:delete` on aggregates, use changesets

40. **Define custom command types**
    ```ruby
    class CustomCreate < ROM::SQL::Commands::Create
      relation :users
      register_as :custom_create

      def execute(tuple)
        tuple[:slug] = tuple[:name].downcase.gsub(/\s+/, '-')
        super
      end
    end

    users.command(:custom_create).call(name: "Jane")
    ```

### Changeset (Validation & Mapping)

41. **Use changesets for data validation and mapping**
    ```ruby
    # Create a changeset with validation
    changeset = users.changeset(:create, name: "Jane", email: "jane@example.com")

    # Validate
    changeset.validate
    # => true/false

    # Commit (persist)
    changeset.commit
    # => #<ROM::Struct[User] id=1 name="Jane" email="jane@example.com">

    # With transaction
    tasks.transaction do
      user = users.changeset(:create, name: "Jane").commit
      tasks.changeset(:create, title: "Task 1").associate(user).commit
    end
    ```
    - Higher-level than commands — includes validation, mapping, and association support
    - Use `changeset.validate` before `commit` for explicit validation
    - `associate(other_struct)` auto-sets foreign keys based on schema associations

42. **Pre-configured mapping in changesets**
    ```ruby
    class NewUserChangeset < ROM::Changeset::Create
      map do
        unwrap :address, prefix: true  # { address: { city: "NYC" } } → address_city: "NYC"
        add_timestamps                  # sets created_at and updated_at
      end
    end

    users.changeset(NewUserChangeset, name: "Jane", address: { city: "NYC" })
    ```

43. **On-demand mapping**
    ```ruby
    users
      .changeset(:create, name: "Joe", email: "joe@example.com")
      .map(:add_timestamps)
      .commit
    ```
    - Built-in transformations: `:add_timestamps`, `:touch`, `unwrap`
    - Also supports all [transproc](https://github.com/solnic/transproc) functions

44. **Custom mapping block**
    ```ruby
    class NewUserChangeset < ROM::Changeset::Create
      map do |tuple|
        tuple.merge(created_on: Date.today)
      end
    end
    ```

### Structs

45. **Define a custom struct**
    ```ruby
    module Main
      module Structs
        class User < Hanami::DB::Struct
          def full_name
            "#{given_name} #{family_name}"
          end

          def mailbox
            "#{full_name} <#{email}>"
          end
        end
      end
    end
    ```
    - Structs are immutable, contain no business logic
    - Extensible for presentation logic
    - If not defined, structs are generated on-demand

46. **Use structs as different projections**
    - Same data, different purposes
    - `User` for general display
    - `Credential` for authentication
    - `Role` for authorization
    - `Visitor` for identity display
    - Application structs can change independently of the database

## Process

When assisting with Hanami DB tasks, follow this workflow:

1. **Identify the persistence layer need**
   - Determine if configuring a new database, defining relations, writing migrations, or creating repositories
   - Clarify the database type (SQLite, PostgreSQL, MySQL)
   - Understand the data relationships (one-to-many, many-to-one, many-to-many)

2. **Configure the database**
    - Set DATABASE_URL for the target environment
    - Configure slice-specific databases if needed
    - Add advanced provider config only when ROM plugins or extensions are required
    - Set up multiple gateways for multi-database scenarios

3. **Define relations**
    - Start with `schema :table, infer: true` as the baseline
    - Override types only where SQL and Ruby types diverge
    - Define associations within the schema block
    - Use custom types via `Types.define` for complex data transformations

4. **Build queries through relations**
    - Use hash-based syntax for simple queries
    - Use expression-based syntax for complex conditions
    - Define scopes on relations for reusable query patterns
    - Set default datasets for consistent query behavior
    - Use `join`/`left_join` for SQL-level joins
    - Use `combine` for loading nested associated data (avoids N+1)
    - Use `node` to adjust nested data within combines

5. **Write data**
    - Use changesets for most operations (validation + mapping built-in)
    - Use commands (`relation.command(:create)`) for bulk operations (~1.5–2x faster)
    - Wrap related writes in `relation.transaction` for atomicity
    - Use `combine(:tasks).command(:create)` for simple nested creates
    - Use changesets for complex writes with validation and association
    - Use `changeset.validate` before `commit` for explicit validation

6. **Write migrations**
    - Use `change` blocks when the reverse can be inferred
    - Provide explicit `up`/`down` for complex operations
    - Use `no_transaction` for operations that don't support transactions (e.g., concurrent index creation)
    - Fall back to raw SQL only when the Sequel DSL cannot express the operation

7. **Create repositories and structs**
    - Encapsulate persistence queries in repositories
    - Use repositories to abstract away schema changes from business logic
    - Define structs only when presentation or projection logic is needed
    - Let auto-generated structs handle simple cases

8. **Review and refine**
   - Verify associations are bidirectional where needed
   - Ensure type coercion handles both read and write directions
   - Check that scopes return chainable relations
   - Confirm migration up/down paths are correct

## Documentation References

When detailed information is needed about specific topics, consult the Hanami DB documentation:

- https://guides.hanamirb.org/v2.3/database/overview/
- https://guides.hanamirb.org/v2.3/database/configuration/
- https://guides.hanamirb.org/v2.3/database/migrations/
- https://guides.hanamirb.org/v2.3/database/relations/

Additional ROM references:
- https://rom-rb.org/learn/core/5.2/combines/
- https://rom-rb.org/learn/core/5.2/mappers/
- https://rom-rb.org/learn/core/5.2/commands/
- https://rom-rb.org/learn/changeset/5.2/mapping/
- https://rom-rb.org/learn/changeset/5.2/associations/
- https://rom-rb.org/learn/sql/3.3/joins/
- https://rom-rb.org/learn/sql/3.3/transactions/
- https://rom-rb.org/learn/repository/5.2/
- https://rom-rb.org/learn/sql/3.3/#connecting-to-a-database

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Relations must be named in the **plural** form
- Always define schemas with `infer: true` as the starting point
- Use `change` blocks in migrations when the reverse operation can be inferred
- Provide explicit `up`/`down` for non-inferable migrations
- Use `no_transaction` only for operations that genuinely cannot run in transactions
- Repositories should encapsulate persistence details from business logic
- Structs should be immutable and contain no business logic
- Prefer hash-based query syntax for simple cases; use expression syntax for complex conditions
- Configure gateways via environment variables (`DATABASE_URL__GATEWAY`) when possible
- Slice DB config inherits from parent by default (`configure_from_parent = true`)
- **NEVER** mix Rails ActiveRecord patterns with Hanami DB

## Best Practices

### Configuration
- Use DATABASE_URL environment variable for all database connections
- Keep advanced provider config minimal — only when plugins or extensions are needed
- Use slice-specific DATABASE_URL only when slices need separate databases
- Use multiple gateways for migration scenarios (e.g., MySQL to PostgreSQL)
- Access DB components via container keys rather than direct instantiation

### Relations
- Start with `schema :table, infer: true` and override only what is necessary
- Use `read:` type coercion when SQL and Ruby types differ
- Define custom types with `Types.define` for complex data (JSONB, UUID, etc.)
- Make associations bidirectional (define both sides)
- Use `ForeignKey` type for non-integer foreign keys
- Alias relations when table names differ from relation names

### Querying
- Use hash-based syntax for simple equality/range queries
- Use expression-based syntax for functions, operators, and complex conditions
- Define scopes for reusable query patterns on relations
- Set default datasets for consistent query behavior across the app
- Use `unfiltered` to bypass default dataset filters when needed
- Query-terminate with `one` for single records, `to_a` for collections

### Joins & Combines
- Use `join`/`left_join`/`right_join` for SQL-level joins in scopes
- Use `combine` to load nested associated data (prevents N+1 queries)
- Remember: ROM never auto-loads associations — always call `combine` explicitly
- Use `node` after `combine` to filter or limit columns in nested relations
- If a nested combine becomes unwieldy, consider splitting into smaller relations

### Transactions
- Wrap related writes in `relation.transaction` for atomicity
- Exceptions trigger automatic rollback
- Use changeset `associate` for automatic foreign key setting in transactions

### Commands & Changesets
- Use changesets for most operations (validation + mapping built-in)
- Use commands for bulk operations when performance matters (~1.5–2x faster)
- Use `combine(:tasks).command(:create)` for simple nested creates
- Use changesets for complex writes requiring validation and association
- Prefer changesets over raw commands for consistency

### Migrations
- Use `change` blocks for simple migrations with auto-inferable reversals
- Write explicit `up`/`down` for complex or non-inferable operations
- Use `no_transaction` only for DDL operations that don't support transactions
- Update `structure.sql` when adding migrations to maintain schema snapshots
- Use raw SQL sparingly — only when the Sequel DSL cannot express the operation
- Name migration files descriptively in snake_case with timestamp prefix

### Repositories
- Encapsulate persistence queries to protect business logic from schema changes
- Use repositories as the primary public API for data access
- Keep repository methods focused on single responsibilities
- Let relations handle query building; repositories handle abstraction

### Structs
- Define structs only when presentation or projection logic is needed
- Keep structs immutable with no business logic
- Use different struct projections for different contexts (authentication, authorization, display)
- Let auto-generated structs handle simple cases without custom definitions
- Application structs can evolve independently of the database schema
