---
name: hanami-views
description: "Expert guidance on building, configuring, and testing Hanami Views"
---

# Hanami Views Specialist v2.x

## Purpose

This skill provides expert guidance on building, configuring, and testing Hanami Views (v2.x). It covers dependencies, input and exposures, templates, helpers, parts, scopes, context, error rendering, and testing strategies.

## Toolbox

### View Dependencies and Exposures

1. **Include dependencies using Deps mixin**
   ```ruby
   module Bookshelf
     module Views
       module Books
         class Show < Bookshelf::View
           include Deps["repos.book_repo"]

           expose :book do |id:|
             book_repo.get!(id)
           end
         end
       end
     end
   end
   ```

2. **Define exposures for template data**
   - Use `expose` method with symbol name
   - Return value from exposure block
   - Values available in templates as locals

3. **Specify input defaults for optional parameters**
   ```ruby
   expose :books do |page: 1, per_page: 20|
     book_repo.listing(page: page, per_page: per_page)
   end
   ```

4. **Create private exposures** (not passed to template)
   ```ruby
   private_expose :author do |author_id:|
     author_repo.get!(author_id)
   end

   expose :author_name do |author|
     author.name
   end
   ```

5. **Make exposure available to layout**
   ```ruby
   expose :recommended_books, layout: true do
     book_repo.recommended_listing
   end
   ```

6. **Disable part decoration for exposures**
   ```ruby
   expose :page_number, decorate: false
   ```

### View Input and Parameters

7. **Receive input from actions**
   - Actions pass parameters to view via `response.render`
   - Access as keyword arguments in exposure blocks
   ```ruby
   # Action
   response.render(view, id: request.params[:id])

   # View
   expose :book do |id:|
     book_repo.get!(id)
   end
   ```

8. **Use response object for input**
   ```ruby
   # Action sets properties on response
   response[:page] = request.params[:page]
   response[:per_page] = request.params[:per_page]

   # View accesses as keyword arguments
   expose :books do |page:, per_page:|
     book_repo.listing(page: page, per_page: per_page)
   end
   ```

9. **Expose input directly to template**
   ```ruby
   expose :query  # query parameter made available in template
   ```

10. **Depend on other exposures**
    ```ruby
    expose :book do |id:|
      book_repo.get!(id)
    end

    expose :author do |book|  # depends on book exposure
      author_repo.get!(book.author_id)
    end
    ```

11. **Access context from exposures**
    ```ruby
    expose :books do |context:|
      book_repo.books_for_user(context.current_user)
    end
    ```

### Templates and Layouts

12. **Use ERB templates by default**
    - File extension: `.html.erb`
    - Template path matches view name
    - Naming scheme: `<name>.<format>.<engine>`

13. **Configure template engines**
    ```ruby
    # app/view.rb
    require "slim"  # for .html.slim templates

    module Bookshelf
      class View < Hanami::View
      end
    end
    ```

14. **Create layouts**
    - Located in `templates/layouts/`
    - Default layout: `app.html.erb`
    - Must include `<%= yield %>` for template content
    ```ruby
    # app/templates/layouts/app.html.erb
    <html>
      <body>
        <%= yield %>
      </body>
    </html>
    ```

15. **Configure layout per view**
    ```ruby
    class Index < Bookshelf::View
      config.layout = "app"  # or false/nil for no layout
    end
    ```

16. **Make exposure available to layouts**
    ```ruby
    expose :page_title, layout: true
    ```

### Helpers

17. **Use standard helpers in templates**
    - Call by method name directly
    - Examples: `format_number`, asset helpers, HTML helpers
    ```html
    <p><%= format_number(1234) %></p>
    ```

18. **Access helpers in parts**
    - Available via `helpers` object
    - Avoids naming collisions with wrapped values
    ```ruby
    class Book < Bookshelf::Views::Part
      def word_count
        helpers.format_number(body_text.split)
      end
    end
    ```

19. **Access helpers in scopes**
    - Available directly as methods (like templates)
    ```ruby
    class MediaPlayer < Bookshelf::Views::Scope
      def display_count
        format_number(items.count)
      end
    end
    ```

20. **Write custom helpers**
    - Defined in `app/views/helpers.rb`
    - Methods available across all templates, parts, scopes
    ```ruby
    module MyApp
      module Views
        module Helpers
          def current_path?(path)
            _context.request.fullpath == path
          end
        end
      end
    end
    ```

21. **Organize helpers in nested modules**
    ```ruby
    module MyApp
      module Views
        module Helpers
          include FormattingHelper  # from formatting_helper.rb
          include UrlHelper         # from url_helper.rb
        end
      end
    end
    ```

### Parts

22. **Define part classes**
    - Located in `Views::Parts` namespace
    - Inherit from base part class
    ```ruby
    # app/views/parts/book.rb
    module Bookshelf
      module Views
        module Parts
          class Book < Bookshelf::Views::Part
          end
        end
      end
    end

    # app/views/part.rb (base class)
    module Bookshelf
      module Views
        class Part < Hanami::View::Part
        end
      end
    end
    ```

23. **Associate parts with exposures**
    - Auto-looked up by exposure name
    - `:book` → `Views::Parts::Book`
    - Arrays: singularized for elements, full name for array
    - Specify explicitly with `as:` option
    ```ruby
    expose :current_user, as: :user  # Uses Views::Parts::User
    expose :books, as: [:item_collection, :item]
    ```

24. **Access decorated value in parts**
    - Delegate methods to wrapped value via `#value` or `#_value`
    - Override methods with custom logic
    ```ruby
    class Book < Bookshelf::Views::Part
      def title
        value.title.upcase
      end

      def display_name
        "#{title} (#{publication_date})"
      end
    end
    ```

25. **Render partials from parts**
    - Part object available in partial locals
    ```ruby
    class Book < Bookshelf::Views::Part
      def info_box
        render("books/info_box")  # book available as local
      end
    end
    ```

26. **Access helpers and context in parts**
    - Helpers: `helpers.method_name`
    - Context: `context.method_name` or `_context` alias
    ```ruby
    class Book < Bookshelf::Views::Part
      def cover_url
        value.cover_url || helpers.asset_url("default.png")
      end

      def path
        context.routes.path(:book, id)
      end
    end
    ```

27. **Decorate part attributes**
    - Wrap attributes with their own parts
    - Memoizes decorated values automatically
    ```ruby
    class Book < Bookshelf::Views::Part
      decorate :author  # Returns Views::Parts::Author
      decorate :reviews, as: :review_collection
    end
    ```

28. **Build scopes from parts**
    ```ruby
    class Book < Bookshelf::Views::Part
      def info_box
        scope(:info_box, size: :large).render
      end
    end
    ```

### Scopes

29. **Define scope classes**
    - Located in `Views::Scopes` namespace
    - Inherit from base scope class
    ```ruby
    # app/views/scopes/media_player.rb
    module Bookshelf
      module Views
        module Scopes
          class MediaPlayer < Bookshelf::Views::Scope
          end
        end
      end
    end

    # app/views/scope.rb (base class)
    module Bookshelf
      module Views
        class Scope < Hanami::View::Scope
        end
      end
    end
    ```

30. **Build scopes in templates**
    - Pass locals to scope constructor
    ```ruby
    scope(:media_player, item: audio_file)
    ```

31. **Access scope locals**
    - Direct access by name within scope class
    - Access all via `#locals` hash with defaults
    ```ruby
    class MediaPlayer < Bookshelf::Views::Scope
      def show_artwork?
        locals.fetch(:show_artwork, true)
      end

      def display_title
        "#{item.title} (#{item.duration})"  # item is local
      end
    end
    ```

32. **Render partials via scopes**
    - Access all scope methods and locals in partial
    ```ruby
    class MediaPlayer < Bookshelf::Views::Scope
      def render_player
        render("media/audio_player")
      end
    end
    ```

33. **Access context from scopes**
    - `context.method_name` or `_context` alias
    - Delegates missing methods to context (if no local with that name)
    ```ruby
    class MediaPlayer < Bookshelf::Views::Scope
      def item_url
        routes.path(:item, item.id)  # delegates to context#routes
      end
    end
    ```

### Context

34. **Use standard context methods**
    - Templates/scopes: implicit access (no receiver needed)
    - Parts/helpers: explicit `context` or `_context` access
    ```ruby
    # Template
    <%= inflector.pluralize("koala") %>
    <%= routes.path(:books) %>

    # Part
    context.inflector.pluralize("koala")
    ```

35. **Access request details in views from actions**
    - `#request` - current HTTP request
    - `#session` - session for current request
    - `#flash` - flash messages from previous request
    - `#csrf_token` - CSRF token helper

36. **Customize context class**
    ```ruby
    # app/views/context.rb
    module Bookshelf
      module Views
        class Context < Hanami::View::Context
          def current_path?(path)
            request.fullpath == path
          end

          include Deps["repos.user_repo"]

          def current_user
            return nil unless session["user_id"]
            @current_user ||= user_repo.get(session["user_id"])
          end
        end
      end
    end
    ```

37. **Decorate context attributes**
    - Wrap attributes with parts automatically
    ```ruby
    class Context < Hanami::View::Context
      decorate :current_user, as: :user
    end
    ```

38. **Provide alternative context object**
    ```ruby
    # Direct rendering
    my_view.call(context: my_alternative_context)

    # From action
    response.render(view, context: my_alternative_context)
    ```

### Error Rendering

39. **Customize error views**
    - Static HTML in `public/404.html` and `public/500.html`
    - Enable/disable via `config.render_errors`
    - Default: true for production, false otherwise

40. **Configure exception to response mapping**
    ```ruby
    # config/app.rb
    class App < Hanami::App
      config.render_error_responses.merge!(
        "ROM::TupleCountMismatchError" => :not_found
      )
    end
    ```

### Rendering from Actions

41. **Automatic view rendering** (default)
    - Action `Pages::Contact` → View `Pages::Contact`
    - Request params passed as input automatically

42. **Explicit view rendering**
    ```ruby
    def handle(request, response)
      response.render(view, page: params[:page])
    end
    ```

43. **Explicit view dependency**
    ```ruby
    class Contact < Bookshelf::Action
      include Deps[view: "views.pages.contact"]

      def handle(request, response)
        # uses specified view dependency
      end
    end
    ```

44. **Conditional view rendering**
    ```ruby
    class Show < Bookshelf::Action
      include Deps[
        view: "views.home.show",
        alternative_view: "views.alternative"
      ]

      def handle(request, response)
        if some_condition
          response.render(alternative_view)
        else
          response.render(view)
        end
      end
    end
    ```

45. **RESTful view dependencies**
    - `Create` action → `New` view
    - `Update` action → `Edit` view
    - Enables sharing views across RESTful actions

46. **Disable automatic rendering**
    ```ruby
    def auto_render?(response)
      false
    end
    ```

### Testing Views

47. **Test views directly**
    ```ruby
    RSpec.describe Views::Profile::Show do
      subject(:view) { described_class.new(users_repo:) }

      let(:user_repo) { double(:user_repo) }
      let(:current_user) { double(name: "Amy", id: 1) }

      it "renders user's own profile" do
        allow(user_repo).to receive(:by_id).with(1).and_return(current_user)
        output = view.call(current_user:, id: 1).to_s
        expect(output).to include("This is your profile")
      end
    end
    ```

48. **Test exposures**
    ```ruby
    describe "exposures" do
      subject(:rendered) { view.call(current_user:) }

      it "exposes current_user" do
        expect(rendered[:current_user].name).to eq("Amy")
      end
    end
    ```

49. **Test parts**
    ```ruby
    RSpec.describe Views::Parts::User do
      subject(:part) { described_class.new(value: user) }

      let(:user) { double(name: "Amy", email: "amy@example.com") }

      it "displays name and email" do
        expect(part.display_name).to eq("Amy (amy@example.com)")
      end
    end
    ```

50. **Test part methods with helpers and partials**
    ```ruby
    describe "#title_tag" do
      it "includes name in h1 tag" do
        expect(part.title_tag).to eq("<h1>Amy (amy@example.com)</h1>")
      end
    end

    describe "#info_card" do
      it "renders info card partial" do
        expect(part.info_card).to start_with('<div class="user-info-card">')
      end
    end
    ```

## Process

When assisting with Hanami Views tasks, follow this workflow:

1. **Identify the view requirements**
   - Determine what data template needs
   - Understand dependency relationships (repos, services)
   - Clarify if standalone or action-rendered view

2. **Design exposure strategy**
   - Recommend which data to expose vs fetch directly
   - Suggest input parameters and defaults
   - Identify private exposures for internal logic
   - Consider layout exposures for shared data

3. **Configure dependencies**
   - Use Deps mixin for repositories and services
   - Ensure proper module nesting in view classes
   - Handle dependencies that may not exist (optional)

4. **Choose appropriate part strategy**
   - Recommend parts for complex value decoration
   - Suggest when to use scopes vs templates
   - Guide on memoization for expensive operations

5. **Organize helpers and context**
   - Identify reusable helper methods
   - Suggest custom context methods for cross-cutting concerns
   - Ensure proper module organization

6. **Implement testing strategy**
   - Recommend direct view tests with dependency injection
   - Suggest parts testing in isolation
   - Guide on mocking dependencies appropriately

7. **Review and refine**
   - Check exposure names don't conflict with helpers
   - Verify part decoration doesn't interfere with value methods
   - Ensure context access is appropriate for each location

## Documentation References

When detailed information is needed about specific topics, consult the Hanami Views documentation:

- https://guides.hanamirb.org/v2.3/views/overview/
- https://guides.hanamirb.org/v2.3/views/working-with-dependencies/
- https://guides.hanamirb.org/v2.3/views/input-and-exposures/
- https://guides.hanamirb.org/v2.3/views/rendering-from-actions/
- https://guides.hanamirb.org/v2.3/views/templates-and-partials/
- https://guides.hanamirb.org/v2.3/views/helpers/
- https://guides.hanamirb.org/v2.3/views/context/
- https://guides.hanamirb.org/v2.3/views/parts/
- https://guides.hanamirb.org/v2.3/views/scopes/
- https://guides.hanamirb.org/v2.3/views/rendering-errors/
- https://guides.hanamirb.org/v2.3/views/configuration/
- https://guides.hanamirb.org/v2.3/views/testing/

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Use Deps mixin for all view dependencies (repos, services)
- Prefer exposure blocks with input parameters over direct fetching
- Use parts to move view-specific behavior out of templates
- Use scopes for template-local behavior around specific data
- Keep helpers stateless and general-purpose
- Decorate context attributes when they need part-like behavior
- Test views in isolation with dependency injection
- Configure error views as static HTML only
- Use `layout: true` sparingly for layout-specific exposures
- **NEVER** use Rails helpers, they are not available in Hanami!

## Best Practices

### View Design
- Keep view classes focused on preparing data for templates
- Use parts to move logic out of templates into testable objects
- Use scopes for template-local behavior around specific data sets
- Prefer simple exposures over complex rendering logic in views
- Organize views, parts, and scopes with consistent module nesting

### Dependencies and Exposures
- Fetch all required dependencies upfront via Deps mixin
- Use exposure blocks with input parameters for dynamic data
- Specify defaults for optional input parameters
- Create private exposures for internal computations
- Make layout-specific exposures available to layouts explicitly

### Parts Strategy
- Use parts when values need view-specific behavior
- Decorate attributes that should be wrapped as parts
- Memoize expensive operations via part class methods
- Access helpers and context via dedicated objects
- Render partials from parts with the part in locals

### Scopes Strategy
- Use scopes for template-local behavior around specific data
- Pass locals to scoping method calls
- Access all scope locals via `#locals` hash for defaults
- Delegate missing methods to context when no local conflicts
- Memoize expensive operations within scope instances

### Helper Organization
- Keep helpers stateless and general-purpose
- Organize into logical nested modules
- Include app helpers in slices that need them
- Use `_context` alias in case of naming conflicts
- Avoid helper names that conflict with exposures

### Context Customization
- Extend context for cross-cutting view concerns
- Add current user, permissions, and utility methods
- Decorate context attributes that need part behavior
- Ensure thread-safety with proper instance variable handling
- Dup mutable variables in `initialize_copy` method

### Testing
- Test views directly with dependency injection
- Mock dependencies to simulate various conditions
- Test exposures separately from rendering logic
- Test parts as standalone objects with values
- Use request specs for end-to-end view testing
- Verify rendered output contains expected content

### Performance
- Memoize expensive operations in part and scope classes
- Use caching for repeated computations
- Avoid N+1 queries by batching repository calls
- Configure appropriate cache headers for action-rendered views
- Consider background rendering for email/async templates

### Security
- HTML escape strings automatically (except with `html_safe`)
- Use helpers for safe string generation
- Validate context methods don't expose sensitive data
- Configure CSP appropriately for inline scripts/styles
- Never bypass escaping without explicit intent
