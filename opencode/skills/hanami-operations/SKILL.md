---
name: hanami-operations
description: "Expert guidance on building, configuring, and testing Hanami Operations"
---

# Hanami Operations Specialist v2.x

## Purpose

This skill provides expert guidance on building, configuring, and testing Hanami Operations (v2.x). Operations organize business logic as a linear flow of steps, forming the foundation of your app's service layer. They are built on top of dry-operation.

## Toolbox

### Operation Basics

1. **Create an operation**
   - Run `bundle exec hanami generate operation <slice>.<name>`
   - Generates a class inheriting from `App::Operation`
   - Implement the `#call` method as the entry point
   ```ruby
   # app/books/create.rb
   module Bookshelf
     module Books
       class Create < Bookshelf::Operation
         def call
         end
       end
     end
   end
   ```

2. **Build a linear flow of steps**
   - Use `step` to chain operations together
   - Each step must return `Success` or `Failure`
   - On `Failure`, execution short-circuits and returns that failure immediately
   - On `Success`, the value is passed to the next step
   ```ruby
   def call(attrs)
     attrs = step validate(attrs)
     book = step create(attrs)
     step update_feeds(book)

     book
   end
   ```

3. **Define private step methods**
   - Each step method receives the previous step's result
   - Return `Success(value)` or `Failure(key, error)`
   ```ruby
   private

   def validate(attrs)
     if valid?(attrs)
       Success(attrs)
     else
       Failure(:invalid, errors: attrs.errors)
     end
   end

   def create(attrs)
     Success(book_repo.create(attrs))
   end

   def update_feeds(book)
     Success(feed_service.update(book))
   end
   ```

### Dependencies

4. **Inject dependencies using Deps mixin**
   - Use `include Deps["dependency.key"]` to inject services, repos, etc.
   - Dependencies are available as reader methods
   ```ruby
   module Bookshelf
     module Books
       class Create < Bookshelf::Operation
         include Deps["repos.book_repo"]
         include Deps["services.feed_service"]

         def call(attrs)
           attrs = step validate(attrs)
           book = step create(attrs)
           step update_feeds(book)

           book
         end

         private

         def create(attrs)
           Success(book_repo.create(attrs))
         end

         def update_feeds(book)
           Success(feed_service.update(book))
         end
       end
     end
   end
   ```

5. **Access dependencies within step methods**
   - Injected dependencies are available as instance methods
   - Use them directly in step logic

### Database Transactions

6. **Wrap steps in a transaction block**
   - Use `transaction do ... end` to wrap database operations
   - Any step failure inside the block rolls back the transaction
   - Also short-circuits the operation on failure
   ```ruby
   def call(attrs)
     transaction do
       attrs = step validate(attrs)
       book = step create(attrs)
       step update_feeds(book)

       book
     end
   end
   ```

7. **Specify a custom gateway**
   - Use `gateway:` option to target a specific database gateway
   ```ruby
   transaction(gateway: :other) do
     attrs = step validate(attrs)
     record = step create(attrs)
     record
   end
   ```

### Working with Results

8. **Pattern match on Success/Failure in callers**
   - Operations return dry-monads `Success` or `Failure` results
   - Use Ruby pattern matching for clean error handling
   ```ruby
   case create.call(params)
   in Success(book)
     response.redirect_to routes.path(:book, book.id)
   in Failure[:invalid, validation]
     response.render view, validation:
   end
   ```

9. **Check result type**
   - `result.success?` / `result.failure?` for type checking
   - `result.value` / `result.failure` for extracting values

10. **Use Failure keys for granular error handling**
    - Return `Failure(:key, **kwargs)` from steps
    - Match on specific keys in case statements
    - Enables precise error handling downstream

### Integration with Actions

11. **Call operations from actions**
    - Inject the operation via Deps mixin
    - Keep actions focused on HTTP concerns only
    ```ruby
    module Bookshelf
      module Actions
        class Create < Bookshelf::Action
          include Deps["books.create"]

          def handle(request, response)
            case create.call(request.params[:book])
            in Success(book)
              response.redirect_to routes.path(:book, book.id)
            in Failure[:invalid, validation]
              response.render view, validation:
            end
          end
        end
      end
    end
    ```

12. **Pass request data to operations**
    - Extract params, headers, or session data in the action
    - Pass relevant data as arguments to `operation.call(...)`
    - Keep operations free of request/response coupling

### Testing Operations

13. **Test operations directly**
    - Instantiate and call the operation with test data
    - Mock dependencies using dependency injection
    ```ruby
    RSpec.describe Books::Create do
      subject(:operation) { described_class.new(book_repo:) }

      let(:book_repo) { instance_double(BookRepo) }

      it "creates a book and returns it" do
        allow(book_repo).to receive(:create).with(title: "Test").and_return(book)
        result = operation.call(title: "Test")

        expect(result).to be_a(Success)
        expect(result.value).to eq(book)
      end

      it "returns failure on invalid input" do
        allow(book_repo).to receive(:create)
        result = operation.call(title: "")

        expect(result).to be_a(Failure)
        expect(result.failure).to eq(invalid: {errors: [...]})
      end
    end
    ```

14. **Test transaction behavior**
    - Verify rollback on step failure
    - Use `transaction` gateway mocking for isolated tests

## Process

When assisting with Hanami Operations tasks, follow this workflow:

1. **Identify the business logic requirements**
   - Determine what data the operation needs as input
   - Understand the steps required to accomplish the task
   - Clarify what success and failure look like

2. **Design the step flow**
   - Break logic into discrete, reusable steps
   - Each step should have a single responsibility
   - Define appropriate Success/Failure return types

3. **Configure dependencies**
   - Identify repos, services, or other dependencies
   - Use Deps mixin to inject them into the operation class
   - Ensure dependencies are available in each step method

4. **Handle database transactions**
   - Wrap related database operations in a `transaction` block
   - Specify custom gateway if needed
   - Ensure all DB writes are inside the transaction

5. **Integrate with callers**
   - Show how to call the operation from actions or other places
   - Demonstrate pattern matching on Success/Failure results
   - Use Failure keys for granular error handling

6. **Write tests**
   - Test the operation in isolation with injected dependencies
   - Mock repos and services
   - Verify both success and failure paths

7. **Review and refine**
   - Check each step returns appropriate Success/Failure
   - Verify transaction boundaries are correct
   - Ensure error handling is clear and explicit

## Documentation References

When detailed information is needed about specific topics, consult the Hanami Operations documentation:

- https://guides.hanamirb.org/v2.3/operations/overview/
- https://dry-rb.org/gems/dry-operation/1.0/
- https://dry-rb.org/gems/dry-monads/1.6/result/

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Operations must inherit from the app's base Operation class
- Every step must return `Success` or `Failure`
- Use `step` for the linear flow; never call step methods directly outside `call`
- Wrap related database writes in `transaction` blocks
- Keep operations free of request/response coupling
- Pattern match on results for explicit error handling
- Test operations in isolation with dependency injection
- Use Failure keys for granular error classification
- Prefer private step methods for each discrete operation

## Best Practices

### Operation Design
- Model logic as a clear linear flow of steps
- Each step should have a single, well-defined responsibility
- Use descriptive method names for step methods
- Keep operations focused on business logic, not infrastructure
- Return meaningful Failure keys for downstream error handling

### Transaction Management
- Wrap all database writes in `transaction` blocks
- Keep non-DB operations (like feed updates) outside the transaction when possible
- Specify gateway explicitly when using non-default databases
- Ensure transaction boundaries align with business requirements

### Error Handling
- Use Failure keys to classify error types (e.g., `:invalid`, `:not_found`)
- Pattern match on results for explicit, readable error handling
- Avoid raising exceptions within operations; use Failure results instead
- Include relevant context in Failure values for debugging

### Dependencies
- Use Deps mixin for all injected dependencies
- Keep dependency list minimal and focused
- Document expected dependency contract in comments when needed

### Testing
- Test operations directly, not through actions
- Mock all external dependencies
- Test both success and failure paths explicitly
- Verify transaction rollback behavior on failure
- Use instance doubles for repos and services in tests

### Integration
- Call operations from actions using Deps injection
- Keep actions focused on HTTP concerns only
- Pass only necessary data from requests to operations
- Handle Success/Failure results explicitly in callers
