---
name: dry-validation
description: "Expert guidance on Dry Validation v1.11: contracts, schemas (schema/params/json), rules (key/ base failures, context, array iteration), messages (explicit, localized, meta-data), macros (global and per-class), external dependencies (option API), extensions (monads, predicates_as_macros, hints), and pattern matching. Use when working with dry-validation, contract objects, validation schemas, or data coercion in Ruby/Hanami projects."
---

# Dry Validation v1.11

Dry Validation is a data validation library that provides a powerful DSL for defining schemas and validation rules. Validations are expressed through contract objects. A contract specifies a schema with basic type checks and any additional rules. Contract rules are applied only when the values they rely on have been successfully verified by the schema.

## Core Concepts

- **Schemas** pre-process data (coerce, type-check) via dry-schema
- **Rules** perform domain-specific validation on schema-verified data
- **Contracts** combine schemas and rules into reusable validation objects
- **Results** return both validated values and error messages

## Setup

```ruby
require 'dry/validation'
```

## Quick Start

```ruby
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:age).value(:integer)
  end

  rule(:email) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('has invalid format')
    end
  end

  rule(:age) do
    key.failure('must be greater than 18') if value <= 18
  end
end

contract = NewUserContract.new
contract.call(email: 'jane@doe.org', age: '17')
# => #<Dry::Validation::Result{:email=>"jane@doe.org", :age=>17}
#    errors={:age=>["must be greater than 18"]}>
```

## Configuration

Use `Contract.config` to set shared configuration. Define an abstract base contract for inheritance:

```ruby
class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :pl
end

class UserContract < ApplicationContract
end

UserContract.config.messages.default_locale  # => :pl
```

### Configuration Settings

| Setting | Purpose | Default |
|---------|---------|---------|
| `config.messages.top_namespace` | Top-level key in locale files | `dry_validation` |
| `config.messages.backend` | Localization backend (`:yaml` or `:i18n`) | `:yaml` |
| `config.messages.load_paths` | Array of file paths for messages | `[]` |
| `config.messages.namespace` | Custom messages namespace per class | — |
| `config.messages.default_locale` | Default I18n-compatible locale | — |

### Custom Messages File

```ruby
# config/errors.yml
en:
  my_app:
    errors:
      taken: "is already taken"
```

```ruby
class ApplicationContract < Dry::Validation::Contract
  config.messages.top_namespace = 'my_app'
  config.messages.load_paths << 'config/errors.yml'
end
```

## Schemas

Schemas are defined inside contracts using three approaches:

### Plain Schema (No Coercion)

```ruby
class NewUserContract < Dry::Validation::Contract
  schema do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end
```

### Params Schema (HTTP Parameters)

```ruby
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end

contract.call('email' => 'jane@doe.org', 'age' => '21')
# => { :email=>"jane@doe.org", :age=>21 }  # strings coerced to integers
```

### JSON Schema

```ruby
class NewUserContract < Dry::Validation::Contract
  json do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end

contract.call('email' => 'jane@doe.org', 'age' => '21')
# => { :email=>"jane@doe.org", :age=>"21" }  # no string coercion
```

JSON natively supports integers, so it won't coerce from strings. Use `params` for HTTP parameters, `json` for raw JSON data.

### Re-using Schemas

Pass existing schemas as arguments:

```ruby
AddressSchema = Dry::Schema.Params do
  required(:country).value(:string)
  required(:zipcode).value(:string)
  required(:street).value(:string)
end

ContactSchema = Dry::Schema.Params do
  required(:email).value(:string)
  required(:mobile).value(:string)
end

class NewUserContract < Dry::Validation::Contract
  params(AddressSchema, ContactSchema) do
    required(:name).value(:string)
    required(:age).value(:integer)
  end
end
```

### Custom Types

Pass explicit type objects:

```ruby
module Types
  include Dry::Types()
  StrippedString = Types::String.constructor(&:strip)
end

class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).value(Types::StrippedString)
  end
end

contract.call(email: '   jane@doe   ')
# => { :email=>"jane@doe" }
```

## Rules

Rules perform domain-specific validation on schema-verified data. A rule only executes when its dependent keys pass schema checks.

### Defining a Rule

```ruby
class EventContract < Dry::Validation::Contract
  params do
    required(:start_date).value(:date)
  end

  rule(:start_date) do
    key.failure('must be in the future') if value <= Date.today
  end
end
```

### Depending on Multiple Keys

```ruby
class EventContract < Dry::Validation::Contract
  params do
    required(:start_date).value(:date)
    required(:end_date).value(:date)
  end

  rule(:end_date, :start_date) do
    key.failure('must be after start date') if values[:end_date] < values[:start_date]
  end
end
```

### Key Path Syntax

```ruby
rule(address: :city) do ... end
rule("address.city") do ... end
rule(address: [:city, :street]) do ... end
```

### Key Failures

`key.failure` sets a message under a specific key. Without arguments, it uses the first key from the rule:

```ruby
rule(:start_date) do
  key.failure('oops')  # equivalent to key(:start_date).failure('oops')
end

rule(:start_date) do
  key(:event_errors).failure('oops')  # sets under different key
end
```

### Base Failures

For errors not tied to a specific key:

```ruby
class EventContract < Dry::Validation::Contract
  option :today, default: Date.method(:today)

  params do
    required(:start_date).value(:date)
    required(:end_date).value(:date)
  end

  rule do
    if today.saturday? || today.sunday?
      base.failure('creating events is allowed only on weekdays')
    end
  end
end

contract.call(start_date: Date.today+1, end_date: Date.today+2).errors.to_h
# => { nil => ["creating events is allowed only on weekdays"] }
```

Filter base errors:
```ruby
result.errors.filter(:base?).map(&:to_s)
```

### Reading Rule Values

```ruby
rule(:start_date) do
  value  # returns values[:start_date]
end

rule(date: :start) do
  value  # returns values[:date][:start]
end

rule(dates: [:start, :stop]) do
  value  # returns [values[:dates][:start], values[:dates][:stop]]
end
```

### Checking Presence

```ruby
rule(:password) do
  key.failure('password is required') if key? && values[:login] && value.length < 12
end
```

### Checking for Previous Errors

```ruby
rule(:name) do
  key.failure('first introduce a valid email') if schema_error?(:email)
end

rule(:email) do
  key.failure('failure added after checking') if rule_error?
end

rule(:email) do
  key.failure('failure added after checking') if rule_error?(:name)
end

rule do
  base.failure('base failure after checking') if base_rule_error?
end
```

### Rules Context

Share data between rules or return fetched data:

```ruby
class UpdateUserContract < Dry::Validation::Contract
  option :user_repo, optional: true

  params do
    required(:user_id).filled(:string)
  end

  rule(:user_id) do |context:|
    context[:user] ||= user_repo.find(value)
    key.failure(:not_found) unless context[:user]
  end
end

contract = UpdateUserContract.new(user_repo: UserRepo.new)
contract.call(user_id: 42).context.each.to_h
# => { user: #<User id: 42> }
```

Pass context via `call` or `default_context`:
```ruby
contract.call({ user_id: 42 }, user: existing_user)
contract = UpdateUserContract.new(default_context: { user: existing_user })
```

### Array Element Rules

Use `.each` to validate each element:

```ruby
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).value(:string)
    optional(:phone_numbers).array(:string)
  end

  rule(:phone_numbers).each do
    key.failure('is not valid') unless value.start_with?('00-')
  end
end

contract.call(email: 'jane@doe.org', phone_numbers: ['00-123', '987-654'])
# => { :phone_numbers => { 1 => ["is not valid"] } }
```

With index for custom error keys:
```ruby
rule(:contacts).each do |index:|
  key([:contacts, :email, index]).failure('email not valid') unless value[:email].include?('@')
end
```

## Messages

Three ways to set failure messages:

### Explicit String

```ruby
key.failure('must be greater than 18')
```

### With Meta-data

```ruby
key.failure(text: 'must be greater than 18', code: 123)
```

### Localized Messages

Configure backend and define YAML:

```yaml
# config/locales/dry_validation.en.yml
en:
  dry_validation:
    errors:
      rules:
        age:
          invalid: "must be greater than 18"
```

```ruby
class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n
end

class NewUserContract < ApplicationContract
  rule(:age) do
    key.failure(:invalid) if values[:age] < 18
  end
end
```

### Full Option with Translated Keys

Define key labels:
```yaml
en:
  dry_validation:
    rules:
      name: "First name"
```

```ruby
contract.call(name: "").errors(full: true).to_h
# => { :name => ["First name must be filled"] }
```

## Macros

Streamline repeated validation rules. **Experimental feature** — API may change in 2.0.

### Global Macro

```ruby
Dry::Validation.register_macro(:email_format) do
  unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
    key.failure('not a valid email format')
  end
end
```

### Per-Class Macro

```ruby
class ApplicationContract < Dry::Validation::Contract
  register_macro(:email_format) do
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
      key.failure('not a valid email format')
    end
  end
end
```

### Using a Macro

```ruby
class NewUserContract < ApplicationContract
  params do
    required(:email).filled(:string)
  end

  rule(:email).validate(:email_format)
end
```

### Macro with Options

```ruby
class ApplicationContract < Dry::Validation::Contract
  register_macro(:min_size) do |macro:|
    min = macro.args[0]
    key.failure("must have at least #{min} elements") unless value.size >= min
  end
end

class NewUserContract < ApplicationContract
  params do
    required(:phone_numbers).value(:array)
  end

  rule(:phone_numbers).validate(min_size: 1)
end
```

### i18n with Macros

```yaml
en:
  dry_validation:
    errors:
      email_format: "not a valid email format"
```

```ruby
register_macro(:email_format) do
  unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
    key.failure(:email_format)
  end
end
```

## External Dependencies

Inject services (DB access, API clients) via `option`:

```ruby
class NewUserContract < Dry::Validation::Contract
  option :address_validator

  params do
    required(:address).filled(:string)
  end

  rule(:address) do
    key.failure("invalid address") unless address_validator.valid?(values[:address])
  end
end

contract = NewUserContract.new(address_validator: your_address_validator)
contract.call(address: "Some Street 15/412")
```

Works with `dry-auto_inject` automatically.

## Extensions

Load with `Dry::Validation.load_extensions`:

### Monads Extension

Makes `Result` compatible with dry-monads:

```ruby
Dry::Validation.load_extensions(:monads)

contract.call(name: "")
  .to_monad
  .fmap { |r| puts "passed: #{r.to_h.inspect}" }
  .or   { |r| puts "failed: #{r.errors.to_h.inspect}" }
```

### Predicates as Macros

Use dry-logic predicates as validation macros:

```ruby
Dry::Validation.load_extensions(:predicates_as_macros)

class ApplicationContract < Dry::Validation::Contract
  import_predicates_as_macros
end

class AgeContract < ApplicationContract
  schema do
    required(:age).filled(:integer)
  end

  rule(:age).validate(gteq?: 18)
end

AgeContract.new.call(age: 17).errors.first.text
# => 'must be greater than or equal to 18'
```

### Hints Extension

Enables hints in Contracts (implemented in dry-schema):

```ruby
Dry::Validation.load_extensions(:hints)
```

## Pattern Matching

Ruby 2.7+ pattern matching on validation results:

```ruby
class PersonContract < Dry::Validation::Contract
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
  end
end

contract = PersonContract.new

case contract.call('first_name' => 'John', 'last_name' => 'Doe')
in { first_name:, last_name: } => result if result.success?
  puts "Hello #{first_name} #{last_name}"
in _ => result
  puts "Invalid input: #{result.errors.to_h}"
end
```

Match as 2-value tuple (output, context):
```ruby
case contract.call('name' => 'John Doe', 'address' => 'Pedro Moreno 10')
in [{ name: }, { address: }] => result if result.success?
  # adding person to existing address
in { name:, address: } => result if result.success?
  # adding person to new address
else
  # showing errors
end
```

With monads extension, avoid `if result.success?`:
```ruby
require 'dry/monads'

Dry::Validation.load_extensions(:monads)

class CreatePerson
  include Dry::Monads[:result]

  class Contract < Dry::Validation::Contract
    params do
      required(:first_name).filled(:string)
      required(:last_name).filled(:string)
    end
  end

  def call(input)
    case contract.call(input).to_monad
    in Success(first_name:, last_name:)
      Success(repo.create(first_name, last_name))
    in Failure(result)
      Failure(result.errors.to_h)
    end
  end
end
```

## Key Patterns

- **Use `params` schema** for HTTP parameter validation (performs type coercion)
- **Use `json` schema** for raw JSON data (no string coercion)
- **Use `schema`** when no coercion is needed
- **Rules only execute** when their dependent keys pass schema checks
- **Use `values[]`** to access multiple dependent values in a rule
- **Use `value`** to access the rule's primary key value
- **Use `key.failure`** for key-specific errors, `base.failure` for whole-input errors
- **Use `key?`** to check if a value is present (important for optional keys)
- **Use `schema_error?`** to check if schema produced errors for another key
- **Use `rule_error?`** to check if the current (or another) rule already added an error
- **Use `base_rule_error?`** to check if any base rule error has occurred
- **Use `context:`** block parameter to share data between rules
- **Use `option`** to inject external dependencies into contracts
- **Use base contract inheritance** to share configuration across many contracts
- **Use macros** to eliminate duplicated validation logic
- **Use `.each`** on array rules to validate each element individually
- **Use `errors(full: true)`** to include translated key names in error output
- **Use the monads extension** for functional error handling with `to_monad`
- **Include `Dry::Monads[:result]`** in pattern-matching classes for Success/Failure
