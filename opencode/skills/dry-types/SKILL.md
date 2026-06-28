---
name: dry-types
description: Expert guidance on Dry Types v1.8: defining types, coercion, constraints, hash schemas, enums, custom types, and extensions. Use when working with dry-types, dry-struct attributes, type definitions, or value coercion in Ruby/Hanami projects.
---

# Dry Types v1.8

Dry Types is a simple and extendable type system for Ruby, useful for value coercions, applying constraints, defining complex structs or value objects. It was created as a successor to Virtus.

## Setup

```ruby
require 'dry-types'
Types = Dry.Types()
```

Verify it works:
```ruby
Types::Coercible::String
# => #<Dry::Types[Constructor<Nominal<String> fn=Kernel.String>]>
```

## Type Categories

Built-in types are grouped under 6 categories:

| Category | Purpose | Example Types |
|----------|---------|---------------|
| `Nominal` | Base type definitions, no checks | `Types::Nominal::String`, `Types::Nominal::Integer` |
| `Strict` | Constrained types with type-check | `Types::Strict::String`, `Types::Strict::Integer` |
| `Coercible` | Types with kernel coercion constructors | `Types::Coercible::String`, `Types::Coercible::Integer` |
| `Params` | Non-strict coercions for HTTP parameters | `Types::Params::Date`, `Types::Params::Bool` |
| `JSON` | Non-strict coercions for JSON | `Types::JSON::Symbol`, `Types::JSON::Decimal` |
| `Maybe` | Accepts nil or specific type | `Types::Maybe::Strict::String` (requires extension) |

Available primitives: `Nil`, `Symbol`, `Class`, `True`, `False`, `Bool`, `Integer`, `Float`, `Decimal`, `String`, `Date`, `DateTime`, `Time`, `Array`, `Hash`.

### Strict vs Coercible

```ruby
# Strict - raises error on wrong type
Types::Strict::Integer[1]      # => 1
Types::Strict::Integer['1']    # => raises Dry::Types::ConstraintError

# Coercible - attempts conversion
Types::Coercible::Integer['1'] # => 1
```

## Optional Values

By default, `nil` raises an error. Append `.optional` to allow `nil`:

```ruby
optional_string = Types::Strict::String.optional
optional_string[nil]           # => nil
optional_string['something']   # => "something"
optional_string[123]           # => raises ConstraintError
```

`Types::String.optional` is syntactic sugar for `Types::Strict::Nil | Types::Strict::String`.

In structs, `.optional` allows `nil` but the key must still be present:

```ruby
class User < Dry::Struct
  attribute :name, Types::String
  attribute :age, Types::Integer.optional
end

User.new(name: 'Bob', age: nil)    # => works
User.new(name: 'Bob')              # => error: :age is missing
```

## Default Values

Returns configured value when input is not defined:

```ruby
PostStatus = Types::String.default('draft')
PostStatus[]              # => "draft"
PostStatus["published"]   # => "published"
PostStatus[true]          # => raises ConstraintError
```

With callable:
```ruby
CallableDateTime = Types::DateTime.default { DateTime.now }
CallableDateTime[]        # => #<DateTime: ...>
```

Pass `Dry::Types::Undefined` explicitly as missing value:
```ruby
PostStatus[Dry::Types::Undefined]  # => "draft"
```

Callable receives type constructor:
```ruby
CallableDateTime = Types::DateTime.constructor(&:to_datetime).default { |type| type[Time.now] }
```

**Warning:** Default values return the same instance. Freeze to prevent mutation issues:
```ruby
PostStatus = Types::Params::String.default('draft'.freeze)
```

**Warning with constrained types:** Default values bypass the constructor, so constraints are not validated on the default itself.

## Fallbacks

Fallback value is returned when **invalid** input is provided (unlike defaults which trigger on missing input):

```ruby
type = Dry::Types['integer'].fallback(100)
type.call(99)        # => 99
type.call('99')      # => 100
type.call(:invalid)  # => 100
```

Block syntax:
```ruby
cnt = 0
type = Dry::Types['integer'].fallback { cnt += 1 }
type.call('99')      # => 1
type.call(:invalid)  # => 2
```

Combined with default:
```ruby
schema = Dry::Types['hash'].schema(
  size: Dry::Types['integer'].fallback(50).default(100)
)
schema.call({})                   # => { size: 100 }
schema.call({ size: 'invalid' })  # => { size: 50 }
```

## Constraints

Use `.constrained` with dry-logic predicates:

```ruby
string = Types::String.constrained(min_size: 3)
string['foo']  # => "foo"
string['fo']   # => raises ConstraintError

email = Types::String.constrained(
  format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
)
```

All dry-logic predicates are supported.

## Hash Schemas

Define types for hashes with known keys:

```ruby
user_hash = Types::Hash.schema(name: Types::String, age: Types::Coercible::Integer)
user_hash[name: 'Jane', age: '21']  # => { name: 'Jane', age: 21 }
```

### Key Behavior

- All keys required by default
- Extra keys omitted by default
- Use `.strict` to reject unknown keys

```ruby
user_hash[name: 'Jane']                    # => MissingKeyError: :age missing
user_hash[name: 'Jane', age: '21', city: 'London']  # => { name: 'Jane', age: 21 }

strict_hash = Types::Hash.schema(name: Types::String).strict
strict_hash[name: 'Jane', age: 21]         # => UnknownKeysError
```

### Optional Keys

Append `?` to key name:
```ruby
user_hash = Types::Hash.schema(name: Types::String, age?: Types::Integer)
user_hash[name: 'Jane']  # => { name: 'Jane' }
```

### Default Values in Schemas

Defaults only evaluate if key is missing:
```ruby
user_hash = Types::Hash.schema(
  name: Types::String,
  age: Types::Integer.default(18)
)
user_hash[name: 'Jane']           # => { name: 'Jane', age: 18 }
user_hash[name: 'Jane', age: nil] # => SchemaError (nil fails constraint)
```

To handle `nil` as missing, wrap with constructor:
```ruby
age: Types::Integer.default(18).constructor { |v| v.nil? ? Dry::Types::Undefined : v }
```

### Key Transform

```ruby
user_hash = Types::Hash.schema(name: Types::String).with_key_transform(&:to_sym)
user_hash['name' => 'Jane']  # => { name: 'Jane' }
```

### Inheritance and Merging

```ruby
# Inheritance
StrictSymbolizingHash = Types::Hash.schema({}).strict.with_key_transform(&:to_sym)
user_hash = StrictSymbolizingHash.schema(name: Types::String)

# Merging
user_with_address = user_hash.merge(address_hash)
```

### Type Transform

```ruby
user_hash = Types::Hash.with_type_transform { |type| type.required(false) }.schema(
  name: Types::String,
  age: Types::Integer
)
user_hash[{}]  # => {}
```

## Array With Member

```ruby
PostStatuses = Types::Array.of(Types::Coercible::String)
PostStatuses[[:foo, :bar]]  # => ["foo", "bar"]
```

Shortcut:
```ruby
ListOfStrings = Types.Array(Types::String)
```

## Enum

Define finite sets of values:

```ruby
class Post < Dry::Struct
  Statuses = Types::String.enum('draft', 'published', 'archived')
  attribute :status, Statuses
end

Post::Statuses['draft']                    # => "draft"
Post::Statuses['something silly']          # => ConstraintError
Post::Statuses.values.frozen?              # => true
```

**Order matters:** call `.default` before `.enum`:
```ruby
Types::String.default('red').enum('blue', 'green', 'red')  # correct
Types::String.enum('blue', 'green', 'red').default('red')  # raises error
```

### Enum Mappings

Map strings to integers (useful for DB/API values):
```ruby
attribute :state, Types::String.enum('locked' => 0, 'open' => 1)

Cell.new(state: 'locked')  # => #<Cell state="locked">
Cell.new(state: 0)         # => #<Cell state="locked">
Cell.new(state: 1)         # => #<Cell state="open">
```

## Map

Homogeneous hashmap with typed keys and values:

```ruby
int_float_hash = Types::Hash.map(Types::Integer, Types::Float)
int_float_hash[100 => 300.0, 42 => 70.0]  # => {100=>300.0, 42=>70.0}
int_float_hash[name: 'Jane']              # => MapError
```

## Combining Types

### Intersection (`&`)

Combines compatible types, requiring properties from each:

```ruby
Id = Types::Hash.schema(id: Types::Integer)
HashWithId = Id & Types::Hash

HashWithId[{ id: 1, message: 'hello' }]   # => {:id=>1, :message=>"hello"}
HashWithId[{ message: 'hello' }]          # => MissingKeyError: :id missing
```

### Sum (`|`)

Allows multiple valid types:

```ruby
nil_or_string = Types::Nil | Types::String
nil_or_string[nil]      # => nil
nil_or_string["hello"]  # => "hello"
nil_or_string[123]      # => ConstraintError
```

`Types::Bool` is defined as `Types::True | Types::False`.

## Custom Types

Helpers available in your `Types` module:

### Types.Instance
```ruby
range_type = Types.Instance(Range)
range_type[1..2]  # => 1..2
```

### Types.Value
```ruby
valid = Types.Value('valid')
valid['valid']    # => 'valid'
```

### Types.Constant
```ruby
valid = Types.Constant(:valid)
valid[:valid]     # => :valid
```

### Types.Constructor
```ruby
user_type = Types.Constructor(User)
user_type[name: 'John']  # equivalent to User.new(name: 'John')

# Custom method
user_type = Types.Constructor(User, User.method(:build))

# Block
user_type = Types.Constructor(User) { |values| User.new(values) }
```

### Types.Nominal
```ruby
int = Types.Nominal(Integer)
int[1]        # => 1
int['one']    # => 'one' (no checks)
```

### Types.Hash
```ruby
Types.Hash(name: Types::String, age: Types::Coercible::Integer)
```

### Types.Array
```ruby
ListOfStrings = Types.Array(Types::String)
```

### Types.Interface
```ruby
Callable = Types.Interface(:call)
Contact  = Types.Interface(:name, :phone)
```

## Custom Type Builders

Chain type transformations idiomatically:

```ruby
source_type = Dry::Types['integer']
constructor_type = source_type.constructor(Kernel.method(:Integer))
constrained_type = constructor_type.constrained(gteq: 18)
```

Extend with `define_builder`:
```ruby
Dry::Types.define_builder(:or) { |type, value| type.fallback(value) }

type = Dry::Types['integer'].or(0)
type.call(10)       # => 10
type.call(:invalid) # => 0
```

## Extensions

Load with `Dry::Types.load_extensions`.

### Maybe Extension

Returns `Some` or `None` instead of raising on `nil`:

```ruby
require 'dry-monads'
include Dry::Monads[:maybe]
require 'dry-types'

Dry::Types.load_extensions(:maybe)
Types = Dry.Types()

Types::Strict::Integer.maybe[nil]   # => None
Types::Strict::Integer.maybe[123]   # => Some(123)

# Or use namespaced types
Types::Maybe::Strict::Integer[nil]  # => None
```

Mapping on Maybe:
```ruby
maybe_string = Types::Strict::String.maybe
maybe_string['something'].fmap(&:upcase).value_or('NOTHING')  # => "SOMETHING"
```

### Monads Extension

Returns `Result` compatible with dry-monads:

```ruby
require 'dry/types'
Dry::Types.load_extensions(:monads)
Types = Dry.Types()

result = Types::String.try('Jane')
monad = result.to_monad  # => Success("Jane")

result = Types::String.try(nil)
monad = result.to_monad  # => Failure([...])
```

**Must use `.try` not `[]`** to get Result objects.

With do notation:
```ruby
class AddTen
  include Dry::Monads[:result, :do]

  def call(input)
    integer = yield Types::Coercible::Integer.try(input)
    Success(integer + 10)
  end
end
```

## Using with Dry::Struct

```ruby
class User < Dry::Struct
  attribute :name, Types::String
  attribute :age, Types::Integer
end

User.new(name: 'Bob', age: 35)  # => #<User name="Bob" age=35>
```

Use strict types for validation:
```ruby
class User < Dry::Struct
  attribute :name, Types::Strict::String
  attribute :age, Types::Strict::Integer.constrained(gteq: 18)
end
```

Use coercible types for conversion:
```ruby
class User < Dry::Struct
  attribute :name, Types::Coercible::String
  attribute :age, Types::Coercible::Integer
end
User.new(name: 'Bob', age: '18')  # => #<User name="Bob" age=18>
```

## Metadata

Attach arbitrary metadata to types:
```ruby
Types::Integer.meta(info: 'extra info about age')
User.schema.key(:age).meta  # => {:info=>"extra info about age"}
```

## Key Patterns

- **Always freeze default values** to prevent mutation bugs
- **Call `.default` before `.enum`** for enum types with defaults
- **Use `.try` not `[]`** when working with monads extension
- **Use `Dry::Types::Undefined`** to explicitly signal missing values
- **Prefer `Types::Strict::*`** in structs for validation safety
- **Use `Types::Params::*`** for HTTP parameter processing
- **Use `Types::JSON::*`** for JSON processing
- **Use `.strict` on hash schemas** to reject unknown keys
- **Use `with_key_transform`** to handle string keys from external sources
- **Use `with_type_transform`** to apply rules to all schema attributes
