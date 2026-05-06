---
name: hanami-logging
description: "Expert guidance on configuring and using Hanami logger for structured logging"
---

# Hanami Logging Specialist v2.x

## Purpose

This skill provides expert guidance on configuring, using, and customizing Hanami's built-in logger (v2.x). It covers default behavior per environment, log formatters, structured logging with payloads, log filtering, colorized output, custom backends, and exception logging.

## Toolbox

### Default Logger Behavior

1. **Understand per-environment defaults**

   Hanami configures the logger differently depending on the environment:

   | Environment | Output | Level | Formatter |
   |---|---|---|---|
   | Development | `$stdout` | `:debug` | text |
   | Test | `logs/test.log` | `:debug` | text |
   | Production | `$stdout` | `:info` | `:json` |

   The defaults typically serve well without changes.

### Logger Configuration

2. **Set global logger configuration**

   Access via `config.logger` in your App class. Settings apply to all environments by default:

   ```ruby
   # config/app.rb

   require "hanami"

   module Bookshelf
     class App < Hanami::App
       # Change formatter for all environments to JSON
       config.logger.formatter = :json
     end
   end
   ```

3. **Fine-tune per-environment**

   Use the `environment` method for environment-specific configuration:

   ```ruby
   # config/app.rb

   require "hanami"

   module Bookshelf
     class App < Hanami::App
       environment(:development) do
         config.logger.stream = root.join("log").join("development.log")
       end
     end
   end
   ```

4. **Enable colorized log levels**

   ```ruby
   # config/app.rb

   require "hanami"

   module Bookshelf
     class App < Hanami::App
       environment(:development) do
         config.logger.options[:colorize] = true
       end
     end
   end
   ```

5. **Customize colorized text template**

   ```ruby
   # config/app.rb

   require "hanami"

   module Bookshelf
     class App < Hanami::App
       environment(:development) do
         config.logger.options[:colorize] = true

         config.logger.template = <<~TMPL
           [<blue>%<progname>s</blue>] [%<severity>s] [<green>%<time>s</green>] %<message>s %<payload>s
         TMPL
       end
     end
   end
   ```

### Log Filters

6. **Configure sensitive data filtering**

   Hanami filters these keys by default to prevent sensitive information leaks:

   - `_csrf`
   - `password`
   - `password_confirmation`

   Add custom filter keys:

   ```ruby
   # config/app.rb

   require "hanami"

   module Bookshelf
     class App < Hanami::App
       config.logger.filters = config.logger.filters + ["token"]
     end
   end
   ```

### Structured Logging with Payloads

7. **Log plain text entries**

   Use logger methods corresponding to log levels:

   ```ruby
   # Console / REPL
   app["logger"].info "Hello World"
   # [bookshelf] [INFO] [2022-11-20 13:47:13 +0100] Hello World

   app["logger"].error "Something's wrong"
   # [bookshelf] [ERROR] [2022-11-20 13:48:05 +0100] Something's wrong
   ```

   Available log levels:

   - `debug`
   - `info`
   - `warn`
   - `error`
   - `fatal`

8. **Log structured data with payloads**

   Hanami supports structured logging by default. Pass data as a payload:

   ```ruby
   # With text message and payload
   app["logger"].info "Hello World", component: "admin"
   # [bookshelf] [INFO] [2022-11-20 13:50:43 +0100] Hello World component="admin"

   # Payload only (text message is optional)
   app["logger"].info text: "Hello World", component: "admin"
   # [bookshelf] [INFO] [2022-11-20 13:51:40 +0100] text="Hello World" component="admin"
   ```

   In production with JSON formatter, payloads become structured JSON fields.

### Logging Exceptions

9. **Log exceptions out of the box**

   Pass rescued exceptions directly to the logger:

   ```ruby
   begin
     raise "OH NOEZ!"
   rescue => e
     app["logger"].error(e)
   end
   # [bookshelf] [ERROR] [2022-11-20 13:54:55 +0100]
   #   OH NOEZ! (RuntimeError)
   #   (pry):7:in `__pry__'
   #   ...
   ```

10. **Log exceptions with additional payload data**

    ```ruby
    begin
      raise "OH NOEZ!"
    rescue => e
      app["logger"].error(e, component: "admin")
    end
    # [bookshelf] [ERROR] [2022-11-20 13:56:36 +0100] component="admin"
    #   OH NOEZ! (RuntimeError)
    #   ...
    ```

### Custom Logging Backends

11. **Add dedicated logging backends**

    Route specific log entries to separate files:

    ```ruby
    # spec/spec_helper.rb

    Hanami.logger.add_backend(
      stream: Hanami.app.root.join("log").join("exceptions.log"), log_if: :exception?
    )

    begin
      raise "Oh noez"
    rescue => e
      Hanami.logger.error(e)
    end
    ```

## Process

When assisting with Hanami Logging tasks, follow this workflow:

1. **Identify the logging requirement**
   - Determine if the need is configuration, structured logging, exception handling, or custom backends
   - Understand which environment(s) are affected
   - Clarify if sensitive data filtering is needed

2. **Configure the logger appropriately**
   - Use global `config.logger` settings for cross-environment changes
   - Use `environment` blocks for per-environment customization
   - Set `formatter` to `:json` for production structured output
   - Enable `:colorize` for development readability

3. **Guide structured logging usage**
   - Encourage payload-based logging over plain text for production
   - Show how to pass data alongside text messages
   - Demonstrate payload-only logging when no message is needed

4. **Address exception logging needs**
   - Show how to pass rescued exceptions to logger methods
   - Demonstrate adding payload context to exception logs
   - Configure custom backends for crash/exception logging

5. **Configure data filtering**
   - Add sensitive field names to `config.logger.filters`
   - Ensure tokens, API keys, or custom fields are filtered

6. **Review and refine**
   - Verify formatter choices match environment needs
   - Check that colorized templates use correct `<color>` tags
   - Ensure custom backends have appropriate `log_if` conditions

## Documentation References

When detailed information is needed about specific topics, consult the Hanami documentation:

- https://guides.hanamirb.org/v2.3/logger/configuration/
- https://guides.hanamirb.org/v2.3/logger/usage/

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Configure logger in `config/app.rb` within the App class
- Use `environment` blocks for per-environment settings (global config affects all environments)
- Use structured payloads in production where JSON parsing is the norm
- Add sensitive field names to `config.logger.filters` to prevent data leaks
- Place custom backend `log_if` conditions carefully to avoid duplicating log entries
- Use `Hanami.logger` or `app["logger"]` to access the logger

## Best Practices

### Configuration
- Keep default logger settings when they meet your needs
- Use `:json` formatter in production for structured log processing
- Use `environment` blocks to override defaults per environment
- Enable `:colorize` in development for easier log reading
- Use `<color>` tags in custom templates (e.g., `<blue>`, `<green>`, `<red>`)

### Structured Logging
- Prefer payloads over plain text messages for production logging
- Use meaningful payload keys (e.g., `component`, `user_id`, `request_id`)
- Log data as structured objects, not concatenated strings
- Use JSON-formatted logs for machine parsing and log aggregation systems

### Exception Logging
- Always rescue exceptions and pass them to the logger
- Include additional context in exception payloads
- Use custom backends for crash logging to separate files
- Never swallow exceptions without logging them

### Security and Filtering
- Review and extend `config.logger.filters` for all sensitive fields
- Add custom tokens, API keys, or PII fields to the filter list
- Verify that filtered keys appear in payloads, not just request params
- Test log output to confirm sensitive data is not exposed

### Custom Backends
- Use `log_if` conditions to route specific severity levels
- Place custom backend setup early in initialization
- Use separate files for different log types (crashes, audit, performance)
- Ensure backend stream paths are writable by the application process
