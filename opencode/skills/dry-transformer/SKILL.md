---
name: dry-transformer
description: "Expert guidance on Dry Transformer v1.1: transformation objects (Pipe DSL), built-in transformations (arrays, hashes, coercions, recursion), and standalone function composition using the registry API. Use when working with dry-transformer, functional data pipelines, or transforming/normalizing structured data in Ruby/Hanami projects."
---

# Dry Transformer v1.1

Dry Transformer is a library that allows you to compose procs into a functional pipeline using left-to-right function composition. It provides a DSL for defining transformation classes, a registry of built-in transformations, and standalone function composition.

## Setup

```ruby
require 'dry/transformer/all'
```

## Transformation Objects

Define transformation classes using the `Pipe` DSL which converts every method call into a corresponding transformation, composing them into a pipeline:

```ruby
class MyMapper < Dry::Transformer::Pipe
  import Dry::Transformer::ArrayTransformations
  import Dry::Transformer::HashTransformations

  define! do
    map_array do
      symbolize_keys
      rename_keys user_name: :name
      nest :address, [:city, :street, :zipcode]
    end
  end
end

mapper = MyMapper.new

mapper.call(
  [
    { 'user_name' => 'Jane',
      'city' => 'NYC',
      'street' => 'Street 1',
      'zipcode' => '123'
    }
  ]
)
# => [{:name=>"Jane", :address=>{:city=>"NYC", :street=>"Street 1", :zipcode=>"123"}}]
```

Inside `define!`, method calls are chained as transformations. Nested blocks create sub-pipelines.

## Built-in Transformations

Dry Transformer ships with several transformation modules:

| Module | Purpose |
|--------|---------|
| `Coercions` | Type coercion functions |
| `ArrayTransformations` | Array manipulation (map_array, filter_array, etc.) |
| `HashTransformations` | Hash manipulation (symbolize_keys, rename_keys, nest, etc.) |
| `ClassTransformations` | Class-related transformations |
| `ProcTransformations` | Proc composition helpers |
| `Conditional` | Conditional transformation logic |
| `Recursion` | Recursive transformation over nested structures |

Import everything into a registry:

```ruby
module T
  extend Dry::Transformer::Registry

  import Dry::Transformer::Coercions
  import Dry::Transformer::ArrayTransformations
  import Dry::Transformer::HashTransformations
  import Dry::Transformer::ClassTransformations
  import Dry::Transformer::ProcTransformations
  import Dry::Transformer::Conditional
  import Dry::Transformer::Recursion
end

T[:to_string].call(:abc) # => 'abc'
```

Import selectively with renaming:

```ruby
module T
  extend Dry::Transformer::Registry

  import :to_string, from: Dry::Transformer::Coercions, as: :stringify
end

T[:stringify].call(:abc) # => 'abc'
```

## Using Standalone Functions

You can use the registry without defining transformation classes:

```ruby
require 'json'
require 'dry/transformer/all'

module Functions
  extend Dry::Transformer::Registry
  import Dry::Transformer::HashTransformations
  import Dry::Transformer::ArrayTransformations
end

# Import from external libraries (e.g. dry-inflector)
require 'dry-inflector'
Inflector = Dry::Inflector.new

module Functions
  import :camelize, from: Inflector, as: :camel_case
end

def t(*args)
  Functions[*args]
end

# Compose transformations with >>
transformation = t(:map_array, t(:symbolize_keys)) >> t(:wrap, :address, [:city, :street, :zipcode])

transformation.call(
  [
    { 'user_name' => 'Jane',
      'city' => 'NYC',
      'street' => 'Street 1',
      'zipcode' => '123' }
  ]
)
# => [{:user_name=>"Jane", :address=>{:city=>"NYC", :street=>"Street 1", :zipcode=>"123"}}]

# Use procs directly
transformation = t(-> v { JSON.dump(v) })
transformation.call(name: 'Jane')
# => "{\"name\":\"Jane\"}"

# Define custom transformations
Functions.register(:load_json) { |v| JSON.load(v) }
transformation = t(:load_json) >> t(:map_array, t(:symbolize_keys))

transformation.call('[{"name":"Jane"}]')
# => [{ :name => "Jane" }]
```

## Key Patterns

- **Use `Pipe` classes** for reusable, named transformation pipelines
- **Use `define!` blocks** for concise, nested transformation DSL
- **Use the registry** (`extend Dry::Transformer::Registry`) for standalone function composition
- **Use `>>`** to compose transformations left-to-right
- **Use `import`** to bring built-in transformations into a registry or Pipe class
- **Use `register`** to add custom transformations to a registry
- **Import selectively** with `import :name, from: Module, as: :alias` to avoid namespace collisions
- **Nest transformations** inside `map_array`, `map_hash`, etc. for scoped pipelines

