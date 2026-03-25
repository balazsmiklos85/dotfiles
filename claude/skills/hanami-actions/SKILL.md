---
name: hanami-actions
description: "Expert guidance on building, configuring, and testing Hanami Actions"
---

# Hanami Actions Specialist v2.x

## Purpose

This skill provides expert guidance on building, configuring, and testing Hanami Actions (v2.x). It covers parameter handling, response management, HTTP features, exception handling, control flow patterns, and testing strategies.

## Toolbox

### Action Structure and Basics

1. **Create a basic action**
   - Define action class inheriting from `Hanami::Action` or app base class
   - Implement `#handle(request, response)` method
   - Return appropriate HTTP responses via the response object

2. **Access request data**
   - Use `request.params` for query/path/body parameters
   - Access headers with `request.headers[:header_name]` or `request.get_header("HEADER_NAME")`
   - Read raw Rack environment via `request.env`
   - Parse nested params safely with `request.params.dig(:key, :nested_key)`

3. **Build responses**
   - Set response body: `response.body = data`
   - Set status code: `response.status = 201` or `response.status = :created`
   - Add headers: `response.headers["X-Custom"] = "value"`
   - Set format: `response.format = :json`

### Parameter Handling and Validation

4. **Define parameter schemas**
   ```ruby
   params do
     required(:email).filled(:string)
     optional(:page).value(:integer, gteq?: 1)
     required(:address).hash do
       required(:street).filled(:string)
     end
   end
   ```

5. **Validate and handle errors**
   - Check validity: `request.params.valid?`
   - Get validation errors: `request.params.errors`
   - Halt on invalid params: `halt 422 unless request.params.valid?`
   - Render JSON errors: `halt 422, {errors: request.params.errors}.to_json`

6. **Use concrete parameter classes**
   - Create separate class inheriting from `Hanami::Action::Params`
   - Reference via `params Params::Create`
   - Enables independent testing and reuse

### Response Formats and Content Negotiation

7. **Configure accepted formats**
   ```ruby
   # App-wide configuration
   config.actions.formats.accept :json, :html

   # Per-action configuration
   config.formats.accept :json
   ```

8. **Set response format dynamically**
   - `response.format = :json` or `response.format = "application/json"`
   - Format determines Content-Type header automatically
   - Mismatched Accept headers return 406 or 415 errors

9. **Register custom formats**
   ```ruby
   config.actions.formats.register :custom, "application/custom"
   config.actions.formats.add :json, ["application/json+scim", "application/json"]
   ```

### HTTP Features

10. **Manage cookies**
    - Set cookie: `response.cookies["name"] = "value"`
    - Configure defaults in app config (domain, path, max_age, secure, httponly)
    - Remove cookie: `response.cookies["name"] = nil`
    - Disable cookies: `config.actions.cookies = nil`

11. **Configure sessions**
    ```ruby
    config.actions.sessions = :cookie, {
      key: "app.session",
      secret: settings.session_secret,
      expire_after: 3600
    }
    ```
    - Set value: `response.session[:key] = value`
    - Read value: `request.session[:key]`
    - Supports cookie and redis adapters

12. **Set Content Security Policy**
    ```ruby
    # Modify existing directive
    config.actions.content_security_policy[:script_src] += " https://cdn.example.com"

    # Replace directive entirely
    config.actions.content_security_policy[:style_src] = "https://cdn.example.com"

    # Disable CSP
    config.actions.content_security_policy = false

    # Use nonces for inline scripts
    config.actions.content_security_policy[:script_src] = "'self' 'nonce'"
    ```

13. **Implement HTTP caching**
    - Set cache control: `response.cache_control :public, max_age: 600`
    - Set expires header: `response.expires 60, :public, max_age: 600`
    - Enable conditional requests: `response.fresh last_modified: time` or `response.fresh etag: "value"`

### Control Flow and Callbacks

14. **Define callbacks**
    ```ruby
    before :authenticate_user!
    after :log_request

    before { |request, response| halt 422 unless valid?(request) }
    ```

15. **Halt execution**
    - `halt 401` returns status with default message
    - `halt 401, "Custom message"` sets custom body
    - Skips remaining action code and callbacks
    - Can be called from within before/after callbacks

16. **Redirect requests**
    ```ruby
    response.redirect_to("/sign-in")
    response.redirect_to(routes.path(:sign_in), status: 301)
    ```

### Exception Handling

17. **Handle exceptions in actions**
    ```ruby
    handle_exception StandardError => 500
    handle_exception RecordNotFound => :handle_not_found

    def handle_not_found(request, response, exception)
      response.status = 404
      response.body = "Resource not found"
    end
    ```

18. **Use string class names** for exceptions from dependencies:
    - `handle_exception "Stripe::CardError" => 400`
    - Avoids requiring dependency in action file

### Action Inheritance

19. **Create base action classes**
    ```ruby
    # apps/action.rb
    module Bookshelf
      class Action < Hanami::Action
        include Deps["authenticator"]
        format :json
        before :authenticate_user!

        private

        def authenticate_user!(request, response)
          halt 401 unless authenticator.valid?(request)
        end
      end
    end
    ```

20. **Use modules for shared behavior**
    ```ruby
    module AuthenticatedAction
      def self.included(action_class)
        action_class.before :authenticate_user!
      end

      private

      def authenticate_user!(request, response)
        # implementation
      end
    end

    class Update < Action
      include AuthenticatedAction
    end
    ```

### Testing Actions

21. **Test actions directly**
    ```ruby
    RSpec.describe Books::Index do
      subject(:action) { Books::Index.new }

      it "returns successful response" do
        response = action.call({})
        expect(response).to be_successful
      end

      it "accepts params and headers" do
        response = action.call(id: "23", "HTTP_ACCEPT" => "application/json")
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
      end
    end
    ```

22. **Inject test dependencies**
    ```ruby
    subject(:action) { Books::Create.new(user_repo: user_repo) }

    let(:user_repo) do
      instance_double(UserRepo).as_null_object
    end

    it "uses injected dependency" do
      expect(user_repo).to receive(:create).with(book_params)
      action.call(book: book_params)
    end
    ```

23. **Write request specs**
    ```ruby
    RSpec.describe "Books", type: :request do
      it "returns list of books" do
        get "/books"
        expect(last_response).to be_successful
        expect(JSON.parse(last_response.body)).to be_an(Array)
      end
    end
    ```

### Rack Integration

24. **Access Rack environment**
    - `request.env["REQUEST_METHOD"]` for raw HTTP data
    - `request.path_info`, `request.user_agent`, etc. via Rack::Request methods

25. **Configure middleware**
    ```ruby
    # App-level middleware
    config.middleware.use Rack::Auth::Basic

    # Insert at specific position
    config.middleware.use Rack::ShowStatus, before: Rack::Auth::Basic

    # Route-specific middleware
    scope "admin" do
      use Rack::Auth::Basic
      get "/books", to: "books.index"
    end
    ```

## Process

When assisting with Hanami Actions tasks, follow this workflow:

1. **Identify the action type and requirements**
   - Determine if building a web app action or API endpoint
   - Clarify expected request/response formats
   - Understand parameter validation needs

2. **Recommend appropriate patterns**
   - Suggest inheritance vs modules based on scope of shared behavior
   - Recommend callback usage for cross-cutting concerns
   - Advise on exception handling strategy (status codes vs custom handlers)

3. **Provide implementation guidance**
   - Show complete action class structure with proper module nesting
   - Include parameter validation schemas matching the data requirements
   - Demonstrate response building for the target format

4. **Address HTTP feature needs**
   - Configure cookies/sessions based on persistence requirements
   - Set up CSP directives for security needs
   - Implement caching strategies for performance optimization

5. **Guide testing implementation**
   - Recommend unit tests for complex action logic
   - Suggest request specs for end-to-end verification
   - Show dependency injection patterns for test isolation

6. **Review and refine**
   - Check parameter validation covers all cases
   - Verify error responses are appropriate
   - Ensure security headers are properly configured

## Documentation References

When detailed information is needed about specific topics, consult the Hanami Actions documentation:

- https://guides.hanamirb.org/v2.3/actions/overview/
- https://guides.hanamirb.org/v2.3/actions/request-and-response/
- https://guides.hanamirb.org/v2.3/actions/inheritance/
- https://guides.hanamirb.org/v2.3/actions/parameters/
- https://guides.hanamirb.org/v2.3/actions/formats-and-media-types/
- https://guides.hanamirb.org/v2.3/actions/status-codes/
- https://guides.hanamirb.org/v2.3/actions/cookies/
- https://guides.hanamirb.org/v2.3/actions/sessions/
- https://guides.hanamirb.org/v2.3/actions/content-security-policy/
- https://guides.hanamirb.org/v2.3/actions/http-caching/
- https://guides.hanamirb.org/v2.3/actions/control-flow/
- https://guides.hanamirb.org/v2.3/actions/exception-handling/
- https://guides.hanamirb.org/v2.3/actions/testing/
- https://guides.hanamirb.org/v2.3/actions/rack-integration/

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Prefer `hanami/action` over direct Rack integration when possible
- Use symbolic status codes (`:ok`, `:created`) for readability
- Validate all user input via parameter schemas before processing
- Handle exceptions explicitly rather than relying on defaults
- Test actions in isolation with dependency injection
- Configure security features (CSP, cookies, sessions) at app level
- Use callbacks for authentication and authorization checks
- Return appropriate HTTP status codes for error conditions
- Document parameter validation constraints clearly

## Best Practices

### Action Design
- Keep action classes focused on a single responsibility
- Use base action classes for shared behavior across many actions
- Prefer modules over inheritance for small, reusable behaviors
- Validate parameters before any business logic processing
- Return meaningful error messages in validation failures

### Security
- Enable CSP with strict defaults and modify minimally
- Use nonces for legitimate inline scripts when CSP enabled
- Set secure and httponly flags on cookies by default
- Validate session secrets are properly configured
- Never trust client-side input; always validate parameters

### Performance
- Implement HTTP caching for read-heavy endpoints
- Use conditional requests with ETag or Last-Modified headers
- Configure appropriate cache-control directives per endpoint
- Minimize database queries in action handlers
- Consider background jobs for long-running operations

### Testing
- Write unit tests for actions with complex validation logic
- Use request specs to verify complete flow from route to response
- Mock only external dependencies, not internal interfaces
- Test parameter coercion and validation edge cases explicitly
- Verify error responses have correct status codes and formats

### Error Handling
- Define exception handlers in base action when possible
- Report exceptions to monitoring services before returning errors
- Log sufficient context for debugging while protecting sensitive data
- Reraise exceptions in development for better visibility
- Return consistent error response format across application
