---
name: hanami-routing
description: "Expert guidance on building, configuring, and managing Hanami Routes"
---

# Hanami Routing Specialist v2.x

## Purpose

This skill provides expert guidance on defining, configuring, and managing Hanami routes (v2.x). It covers basic routes, resource routing, path matching, named helpers, scopes, redirects, and route inspection.

## Toolbox

### Defining Basic Routes

1. **Create a basic route**
   - Define route in `config/routes.rb` inside the `Routes` class
   - Specify HTTP method, path, and endpoint
   - Endpoint can be an action name, block, or Rack app

   ```ruby
   get "/books", to: "books.index"
   post "/books", to: "books.create"
   put "/books/:id", to: "books.update"
   patch "/books/:id", to: "books.update"
   delete "/books/:id", to: "books.destroy"
   ```

2. **Use blocks and Rack apps as endpoints**

   ```ruby
   get "/hello" do
     [200, {}, ["Hello from Hanami"]]
   end

   get "/rack-app", to: RackApp.new
   get "/lambda", to: ->(env) { [200, {}, ["Lambda response"]] }
   ```

3. **Define root route**

   ```ruby
   root { "Hello from Hanami" }

   # Or invoke an action
   root to: "home"
   ```

### Resource Routes

4. **Create collection resources**

   ```ruby
   resources :books
   ```

   Generates:

   | HTTP Method | Path | Action |
   |---|---|---|
   | GET | /books | books.index |
   | GET | /books/:id | books.show |
   | GET | /books/new | books.new |
   | POST | /books | books.create |
   | GET | /books/:id/edit | books.edit |
   | PATCH | /books/:id | books.update |
   | DELETE | /books/:id | books.destroy |

5. **Create singleton resources**

   ```ruby
   resource :profile
   ```

   Generates routes for `/profile` (no index, no `:id`) without a collection endpoint.

6. **Filter resource actions**

   ```ruby
   # Only specific actions
   resources :books, only: [:index, :show]

   # Exclude specific actions
   resources :books, except: [:destroy]
   ```

7. **Customize resource routes**

   ```ruby
   # Custom URL path
   resources :comments, path: "reviews"

   # Custom action namespace
   resources :books, to: "library.books"

   # Custom route name
   resources :books, as: :publications
   ```

8. **Nest resources**

   ```ruby
   resources :books do
     resources :reviews
   end
   ```

   Generates nested routes like `/books/:book_id/reviews`. Actions are namespaced under the parent (e.g., `books.reviews.index`).

9. **Mix basic routes within resources**

   ```ruby
   resources :books do
     get "/latest", to: "books.latest"
   end
   ```

### Path Matching and Variables

10. **Use path variables**

    ```ruby
    get "/books/:id", to: "books.show"

    # In action:
    request.params[:id] # => "1"
    ```

    Multiple variables:

    ```ruby
    get "/books/:book_id/reviews/:id", to: "book_reviews.show"

    # In action:
    request.params[:book_id] # => "17"
    request.params[:id]      # => "6"
    ```

11. **Add constraints to path variables**

    ```ruby
    get "/books/:id", id: /\d+/, to: "books.show"

    # GET /books/2   # matches
    # GET /books/two # does not match

    get "/books/award-winners/:year", year: /\d{4}/, to: "books.award_winners.index"

    # GET /books/award-winners/2022 # matches
    # GET /books/award-winners/2    # does not match
    ```

12. **Use globbing for catch-all routes**

    ```ruby
    get "/pages/*path", to: "page_catch_all"

    # GET /pages/2022/my-page
    # request.params[:path] # => "2022/my-page"

    # Global catch-all (place last)
    get "/*path", to: "unmatched"
    ```

### Named Routes and URL Helpers

13. **Name routes for URL helpers**

    ```ruby
    get "/books", to: "books.index", as: :books
    get "/books/:id", to: "books.show", as: :book
    ```

    Access helpers:

    ```ruby
    Hanami.app["routes"].path(:books)
    => "/books"

    Hanami.app["routes"].path(:book, id: 1)
    => "/books/1"

    Hanami.app["routes"].url(:book, id: 1)
    => #<URI::HTTP http://0.0.0.0:2300/books/1>
    ```

14. **Configure base URL for `url` helpers**

    ```ruby
    # config/app.rb
    module Bookshelf
      class App < Hanami::App
        config.base_url = "https://bookshelf.example.com"
      end
    end
    ```

### Scopes

15. **Use scopes for route prefixing and namespacing**

    ```ruby
    scope "about" do
      get "/contact-us", to: "content.contact", as: :contact  # => /about/contact-us
      get "/faq", to: "content.faq", as: :faq                 # => /about/faq
    end
    ```

    Named routes get prefix: `:about_contact`, `:about_faq`.

16. **Scope with path variables**

    ```ruby
    scope "authors/:author_id", as: :author do
      resources :books, only: [:index, :show], to: "authors.books"
      get "/news", to: "authors.news", as: :news
    end
    ```

    Generates:

    ```
    GET  /authors/:author_id/books      authors.books.index  :author_books
    GET  /authors/:author_id/books/:id  authors.books.show   :author_book
    GET  /authors/:author_id/news       authors.news         :author_news
    ```

17. **Customize scope route name prefix**

    ```ruby
    scope "authors/:author_id", as: :author do
      get "send-feedback", to: "authors.send_feedback", as: [:send, :feedback]
      # Named :send_author_feedback (array inserts scope prefix between elements)
    end
    ```

### Redirects

18. **Add redirects**

    ```ruby
    # Basic redirect (301)
    redirect "/old", to: "/new"

    # Custom status code
    redirect "/old", to: "/temporary-new", code: 302

    # Absolute URL
    redirect "/external", to: "http://hanamirb.org"

    # Non-HTTP protocols
    redirect "/custom", to: URI("xmpp://myapp.net")
    ```

### Inspecting Routes

19. **List routes via CLI**

    ```shell
    bundle exec hanami routes
    ```

    Output:

    ```
    GET     /                             home                          as :root
    GET     /books                        books.index
    GET     /books/:id                    books.show
    GET     /books/new                    books.new
    POST    /books                        books.create
    GET     /books/:id/edit               books.edit
    PATCH   /books/:id                    books.update
    DELETE  /books/:id                    books.destroy
    ```

## Process

When assisting with Hanami Routing tasks, follow this workflow:

1. **Identify the routing requirements**
   - Determine if the route is a simple endpoint, a resource, or part of a nested structure
   - Clarify expected HTTP methods and path patterns
   - Understand if URL helpers are needed

2. **Choose the appropriate route type**
   - Use `resources` for full CRUD collections
   - Use `resource` for singleton endpoints
   - Use basic routes for custom or non-RESTful paths
   - Use scopes for grouping and namespacing

3. **Provide implementation guidance**
   - Show complete route definitions with proper module nesting context
   - Include path variables and constraints where needed
   - Add route names for URL helper access
   - Demonstrate nested resources and scope usage

4. **Address naming and helper needs**
   - Configure `as` options for meaningful route names
   - Show how to use `path` and `url` helpers
   - Configure `base_url` when URL helpers need a domain

5. **Guide route inspection and debugging**
   - Recommend `bundle exec hanami routes` for verification
   - Help troubleshoot route conflicts or unmatched patterns

6. **Review and refine**
   - Verify path variable names match action usage
   - Check constraint patterns are appropriate
   - Ensure redirect codes are semantically correct (301 vs 302)

## Documentation References

When detailed information is needed about specific topics, consult the Hanami documentation:

- https://guides.hanamirb.org/v2.3/routing/overview/
- https://guides.hanamirb.org/v2.3/actions/parameters/
- https://github.com/hanami/router

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Define routes in `config/routes.rb` within the `Routes` class
- Use `resources` (plural) for collection resources, `resource` (singular) for singletons
- Place catch-all routes (`/*path`) last to avoid shadowing other routes
- Use meaningful `as` names for all routes that need URL helpers
- Validate path variable constraint patterns match expected data formats
- Use `base_url` config for production `url` helper output

## Best Practices

### Route Design
- Use `resources` for standard CRUD endpoints to reduce boilerplate
- Prefer path variables over query strings for resource identifiers
- Use constraints to narrow path variable matches and improve specificity
- Nest resources to reflect hierarchical domain relationships
- Use scopes to group related routes and reduce repetition

### Naming Conventions
- Use `as` for all routes that will be referenced via URL helpers
- Name routes using resource-oriented names (e.g., `:books`, `:book`)
- Use scope `as` to create meaningful prefixed route names
- Avoid overly generic route names that could conflict

### Debugging and Maintenance
- Run `bundle exec hanami routes` after adding or modifying routes
- Check route ordering — more specific routes should come before catch-all
- Use `only` and `except` to keep resource routes minimal when needed
- Document complex globbing or constraint patterns with comments

### Redirects
- Use 301 for permanent moves, 302 for temporary redirects
- Prefer route names over hardcoded paths in redirects when possible
- Use middleware for complex redirect logic or bulk redirects
