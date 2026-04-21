---
name: hanami-helpers
description: "Expert guidance on Hanami Helpers: string escaping, HTML, assets, and number formatting"
---

# Hanami Helpers Specialist v2.x

## Purpose

This skill provides expert guidance on Hanami Helpers (v2.x), which offer a range of standard helpers for use in views. Helpers are available in templates (called directly by method name), parts (via `helpers` object), and scopes (as methods). They cover string escaping, HTML tag generation, asset URLs and tags, and number formatting. You can also write custom helpers in `app/views/helpers.rb` and organize them in nested modules.

## Toolbox

### String Escaping

**1. Escape HTML in templates**
   - `escape_html(str)` (aliased as `h`) returns an escaped string safe for HTML templates
   - Marks the result as HTML safe to prevent double-escaping
   - Use for any untrusted user input in HTML content
   ```ruby
   escape_html("<script>alert('xss')</script>")
   # => "&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;"

   escape_html("<p>Safe content</p>")
   # => "<p>Safe content</p>"
   ```

**2. Bypass HTML escaping**
   - `raw(str)` returns the string marked as HTML safe regardless of content
   - NOT recommended for untrusted user input
   ```ruby
   raw(user.name)
   # => "Little Bobby <alert>Tables</alert>"

   raw(user.name).html_safe?
   # => true
   ```

**3. Sanitize URLs**
   - `sanitize_url(url, schemes = %w[http https mailto])` returns the URL if it has a permitted scheme
   - Returns empty string for non-permitted schemes
   - Use for URLs from untrusted user input
   ```ruby
   sanitize_url("https://hanamirb.org")
   # => "https://hanamirb.org"

   sanitize_url("javascript:alert('xss')")
   # => ""

   sanitize_url("gemini://example.com/", %w[http https gemini])
   # => "gemini://example.com/"
   ```

### HTML Helpers

**4. Build HTML tags with `tag`**
   - `tag` returns a tag builder; chain any HTML element method
   - Provide content as first argument, block return, or nested tag calls
   - Use keyword arguments for attributes; arrays concatenate, hashes include only truthy keys
   - Attributes and contents are auto-escaped unless marked HTML safe
   ```ruby
   tag.div                    # => "<div></div>"
   tag.img                    # => "<img>"
   tag.div("hello")           # => "<div>hello</div>"
   tag.div { "hello" }        # => "<div>hello</div>"
   tag.div(tag.p("hello"))    # => "<div><p>hello</p></div>"
   tag.div(class: "a")        # => "<div class=\"a\"></div>"
   tag.div(class: ["a", "b"])                    # => "<div class=\"a b\"></div>"
   tag.div(class: {a: true, b: false})           # => "<div class=\"a\"></div>"
   tag.custom_tag("hello")  # => "<custom-tag>hello</custom-tag>"
   ```

**5. Build token lists for attributes**
   - `token_list(...)` (aliased as `class_names`) returns space-separated tokens
   - Intended for HTML attribute values like class lists
   - Filters nil, false, and empty strings; includes keys with truthy hash values
   ```ruby
   token_list("foo", "bar")
   # => "foo bar"

   token_list("foo", "foo bar")
   # => "foo bar"

   token_list({foo: true, bar: false})
   # => "foo"

   token_list(nil, false, 123, "", "foo", {bar: true})
   # => "123 foo bar"
   ```

**6. Generate links**
   - `link_to(contents, url, **attributes)` returns an anchor tag
   - `link_to(url) { contents }` block form
   - Contents are auto-escaped unless HTML safe
   ```ruby
   link_to("Home", "/")
   # => "<a href=\"/\">Home</a>"

   link_to("/") { "Home" }
   # => "<a href=\"/\">Home</a>"

   link_to("Home", "/", class: "button")
   # => "<a href=\"/\" class=\"button\">Home</a>"
   ```

### Asset Helpers

**7. Get asset URLs**
   - `asset_url(source)` returns the URL for a given asset source
   - Looks up asset based on app or slice context
   ```ruby
   asset_url("app.js")
   # => "/assets/app-LSLFPUMX.js"
   ```

**8. Generate script tags**
   - `javascript_tag(source, **attributes)` returns a `<script>` tag
   - Accepts asset path or absolute URL
   - Adds `.js` extension if omitted
   - Multiple sources generate multiple tags
   - Use block for additional attributes
   ```ruby
   javascript_tag("app.js")
   # => "<script src=\"/assets/app-LSLFPUMX.js\" type=\"text/javascript\"></script>"

   javascript_tag("https://example.com/example.js")
   # => "<script src=\"https://example.com/example.js\" type=\"text/javascript\"></script>"

   javascript_tag("app")
   # => "<script src=\"/assets/app-LSLFPUMX.js\" type=\"text/javascript\"></script>"

   javascript_tag("app", "dashboard/app")
   # => multiple <script> tags

   javascript_tag("app", async: true)
   # => "<script src=\"/assets/app-LSLFPUMX.js\" type=\"text/javascript\" async=\"async\"></script>"
   ```

**9. Generate stylesheet tags**
   - `stylesheet_tag(source, **attributes)` returns a `<link>` tag
   - Accepts asset path or absolute URL
   - Adds `.css` extension if omitted
   - Multiple sources generate multiple tags
   ```ruby
   stylesheet_tag("app.css")
   # => "<link href=\"/assets/app-GVDAEYEC.css\" type=\"text/css\" rel=\"stylesheet\">"

   stylesheet_tag("https://example.com/stylesheet.css")
   # => "<link href=\"https://example.com/stylesheet.css\" type=\"text/css\" rel=\"stylesheet\">"

   stylesheet_tag("app")
   # => "<link href=\"/assets/app-GVDAEYEC.css\" type=\"text/css\" rel=\"stylesheet\">"

   stylesheet_tag("app", "dashboard/app")
   # => multiple <link> tags

   stylesheet_tag("https://example.com/print.css", media: "print")
   # => "<link href=\"...\" type=\"text/css\" rel=\"stylesheet\" media=\"print\">"
   ```

**10. Generate image tags**
    - `image_tag(source, **attributes)` returns an `<img>` tag
    - Auto-generates `alt` attribute from filename
    - Accepts asset path or absolute URL
    ```ruby
    image_tag("logo.png")
    # => "<img src=\"/assets/logo-DJHI6WQI.png\" alt=\"Logo\">"

    image_tag("https://example.com/logo.png")
    # => "<img src=\"https://example.com/logo.png\" alt=\"Logo\">"

    image_tag("logo.png", alt: "App logo", class: "image")
    # => "<img src=\"/assets/logo-DJHI6WQI.png\" alt=\"App logo\" class=\"image\">"
    ```

**11. Generate favicon tags**
    - `favicon_tag(source, **attributes)` returns a `<link>` tag for favicon
    - Defaults to `favicon.ico` if no source given
    ```ruby
    favicon_tag
    # => "<link href=\"/assets/favicon-RTK3P5FP.ico\" rel=\"shortcut icon\" type=\"image/x-icon\">"

    favicon_tag("fav.ico", id: "fav")
    # => "<link id=\"fav\" href=\"/assets/fav-EOLTKYGO.ico\" rel=\"shortcut icon\" type=\"image/x-icon\">"
    ```

**12. Generate video tags**
    - `video_tag(source, **attributes)` returns a `<video>` tag
    - Accepts asset path or absolute URL
    - Use block for fallback content or `<track>` elements
    ```ruby
    video_tag("movie.mp4")
    # => "<video src=\"/assets/movie-DJHI6WQI.mp4\"></video>"

    video_tag("movie.mp4", autoplay: true, controls: true)
    # => "<video autoplay=\"autoplay\" controls=\"controls\" src=\"/assets/movie-DJHI6WQI.mp4\"></video>"

    video_tag("movie.mp4") do
      "Your browser does not support the video tag."
    end

    video_tag("movie.mp4") do
      tag.track(kind: "captions", src: asset_url("movie.en.vtt"), srclang: "en", label: "English")
    end
    ```

**13. Generate audio tags**
    - `audio_tag(source, **attributes)` returns an `<audio>` tag
    - Accepts asset path or absolute URL
    - Use block for fallback content or `<track>` elements
    ```ruby
    audio_tag("song.ogg")
    # => "<audio src=\"/assets/song-DJHI6WQI.ogg\"></audio>"

    audio_tag("song.ogg", autoplay: true, controls: true)
    # => "<audio autoplay=\"autoplay\" controls=\"controls\" src=\"/assets/song-DJHI6WQI.ogg\"></audio>"

    audio_tag("song.ogg") do
      "Your browser does not support the audio tag."
    end
    ```

### Number Formatting

**14. Format numbers with commas**
    - `format_number(number, **options)` returns a formatted string
    - Integer input: no decimal places
    - Float/BigDecimal input: formats as float with default precision of 2
    - Options: `precision`, `delimiter`, `separator`
    ```ruby
    format_number(1_000_000)
    # => "1,000,000"

    format_number(1_000_000.10)
    # => "1,000,000.00"

    format_number(Math::PI)
    # => "3.14"

    format_number(Math::PI, precision: 6)
    # => "3.141592"

    format_number(1_000_000, delimiter: '.')
    # => "1.000.000"

    format_number(1.23, separator: ',')
    # => "1,23"
    ```

### Custom Helpers

**15. Write custom helpers**
    - Defined in `app/views/helpers.rb`
    - Methods available in all templates, parts, and scopes
    - Access context via `_context` or `context`
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

**16. Organize helpers in nested modules**
    - Split helpers into separate files for organization
    - Include modules in the main Helpers module
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

### Accessing Helpers in Different Contexts

**17. Call helpers in templates**
    - Call by method name directly, no receiver needed
    ```html
    <p><%= format_number(1234) %></p>
    <%= link_to("Home", "/") %>
    ```

**18. Access helpers in parts**
    - Available via `helpers` object to avoid naming collisions with `value`
    ```ruby
    class Book < Bookshelf::Views::Part
      def word_count
        helpers.format_number(body_text.split.size)
      end

      def cover_url
        value.cover_url || helpers.asset_url("default.png")
      end
    end
    ```

**19. Access helpers in scopes**
    - Available directly as methods, like templates
    ```ruby
    class MediaPlayer < Bookshelf::Views::Scope
      def display_count
        format_number(items.count)
      end
    end
    ```

## Process

When assisting with Hanami Helpers tasks, follow this workflow:

1. **Identify the helper category and need**
   - Determine if using standard helper (escaping, HTML, assets, number) or custom
   - Understand the context: template, part, or scope
   - Clarify if dealing with trusted or untrusted input

2. **Recommend appropriate standard helper**
   - Use `escape_html`/`sanitize_url` for untrusted input
   - Use `tag` builder for custom HTML structure
   - Use asset helpers for app/slice assets or CDNs
   - Use `format_number` for readable number display

3. **Provide implementation guidance**
   - Show correct helper method and options for the use case
   - Demonstrate proper attribute handling (arrays, hashes for conditional classes)
   - Include content escaping considerations

4. **Guide custom helper creation when needed**
   - Recommend `app/views/helpers.rb` for app-wide helpers
   - Suggest nested modules for organizing many helpers
   - Show how to access context from helpers

5. **Address context-specific access patterns**
   - Templates: call directly by name
   - Parts: use `helpers.method_name`
   - Scopes: call directly by name

6. **Review and refine**
   - Verify escaping is applied for untrusted input
   - Ensure asset helpers use correct source paths
   - Confirm helper access pattern matches the context

## Documentation References

When detailed information is needed about specific topics, consult the Hanami Helpers documentation:

- https://guides.hanamirb.org/v2.3/helpers/overview/
- https://guides.hanamirb.org/v2.3/helpers/string-escaping/
- https://guides.hanamirb.org/v2.3/helpers/html/
- https://guides.hanamirb.org/v2.3/helpers/assets/
- https://guides.hanamirb.org/v2.3/helpers/number-formatting/

## Constraints

- Always use Hanami v2.x helper conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- HTML escape untrusted input via `escape_html` or `sanitize_url`
- Use `raw` only for trusted content; never for user input
- Prefer asset helpers for app/slice assets over hard-coded paths
- Access helpers correctly per context: direct in templates/scopes, via `helpers` in parts
- Write custom helpers in `app/views/helpers.rb` with proper module nesting
- Avoid helper names that conflict with exposure names
- **NEVER** use Rails helpers, they are not available in Hanami!

## Best Practices

### Security
- Always escape untrusted user input with `escape_html` before including in HTML
- Use `sanitize_url` for URLs from untrusted sources to prevent XSS
- Reserve `raw` for explicitly trusted content only
- HTML escape string contents in `tag` builder (except when marked HTML safe)
- Validate URL schemes before rendering user-provided links

### HTML Helpers
- Use `tag` builder for dynamic HTML structure instead of string interpolation
- Use arrays for multiple class values, hashes for conditional classes
- Prefer `token_list`/`class_names` for building class attribute values
- Use block form of `link_to` for dynamic link contents
- Leverage auto-escaping in tag builder for content and attributes

### Asset Helpers
- Use `asset_url` for getting asset URLs without generating tags
- Use `javascript_tag`/`stylesheet_tag` for simple single-asset inclusion
- Use multiple sources for batch inclusion of assets
- Pass HTML attributes as keyword arguments for customization
- Use absolute URLs when loading from CDN or external sources
- Leverage video/audio block form for fallback content or subtitles

### Number Formatting
- Use `format_number` for all number display in templates
- Customize `precision`, `delimiter`, and `separator` for locale-specific formatting
- Remember integers get no decimal places by default
- Use `precision` option for consistent decimal display across types

### Custom Helpers
- Keep helpers stateless and general-purpose
- Organize into logical nested modules by concern
- Use `_context` alias when naming conflicts with helpers exist
- Document helper methods with clear parameter and return descriptions
- Include app helpers in slices that need them via module inclusion

### Testing
- Test custom helpers as standalone methods with mocked context
- Verify escaping behavior for security-critical helpers
- Test asset helpers with mocked asset pipeline
- Check helper output contains expected HTML structure
