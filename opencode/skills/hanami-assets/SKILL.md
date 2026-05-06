---
name: hanami-assets
description: "Expert guidance on building, configuring, and managing Hanami Assets"
---

# Hanami Assets Specialist v2.x

## Purpose

This skill provides expert guidance on building, configuring, and managing Hanami Assets (v2.x). It covers the asset structure, entry points, bundles, compilation, CLI commands, helpers, CDN configuration, and customization.

## Toolbox

### Asset Structure

1. **Understand the default asset layout**

   A new Hanami app provides:

   ```
   .
   ├── app
   │   ├── assets
   │   │   ├── css
   │   │   │   └── app.css
   │   │   ├── images
   │   │   │   └── favicon.ico
   │   │   └── js
   │   │       └── app.js
   ├── config
   │   └── assets.js
   ├── package.json
   └── public
       └── assets
           ├── assets.json
           ├── app-HYVEQYF6.css
           ├── app-6PW7FGD5.js
           └── favicon-5VHYTKP2.ico
   ```

   - `app/assets/` — source assets directory
   - `app/assets/css/` — stylesheets (special directory)
   - `app/assets/js/` — JavaScript files (special directory)
   - `app/assets/images/` — static assets (images, fonts, etc.)
   - `config/assets.js` — esbuild compilation configuration
   - `public/assets/` — compiled output directory
   - `public/assets/assets.json` — manifest file for locating compiled assets

2. **Understand slice asset layout**

   Slices have their own independent assets under their own `assets/` directory:

   ```
   slices/admin
   └── assets
       ├── css
       │   └── app.css
       └── js
           └── app.js
   ```

   Compiled output goes to `public/assets/_admin/` (underscored to prevent collisions).

### Entry Points

3. **Use the default entry point**

   The default entry point is `app/assets/js/app.js`:

   ```javascript
   import "../css/app.css";
   ```

   Only files referenced by an entry point will be included in the final bundle.

4. **Create multiple entry points**

   Create any directory under `js/` with a file named `app.js` inside it:

   ```
   app/assets/js/
   ├── app.js           # Default entry point
   └── signin/
       ├── app.js       # Sign-in page entry point
       └── resetPassword.js
   ```

   ```javascript
   // app/assets/js/signin/app.js
   import "../../css/signin/app.css";
   import { resetPassword } from "./resetPassword";
   ```

   Supported extensions: `.js`, `.mjs`, `.ts`, `.mts`, `.tsx`, `.jsx`.

5. **Understand entry point output**

   Each entry point generates its own bundle under `public/assets/`:

   ```
   public/assets/
   ├── assets.json
   ├── app-GVDAEYEC.css
   ├── app-LSLFPUMX.js
   └── signin/
       ├── app-JPZQ4M77.css
       └── app-LSLFPUMX.js
   ```

### Asset Bundles

6. **Understand asset bundling**

   - An asset bundle groups multiple files referenced from an entry point into a single file
   - Reduces HTTP requests for better page performance
   - esbuild provides fast bundling with tree shaking and dead code elimination
   - Multiple bundles allow loading only required assets per page

### Asset Compilation

7. **Compile assets for production**

   ```shell
   bundle exec hanami assets compile
   ```

   Production output:
   - Content-hashed filenames (e.g., `app-LSLFPUMX.js`)
   - Minified files
   - Source maps generated
   - Manifest written to `public/assets/assets.json`

8. **Watch assets in development**

   ```shell
   bundle exec hanami assets watch
   ```

   Development output:
   - No content hash in filenames
   - Not minified
   - No source maps

   The `hanami dev` command starts `hanami assets watch` by default.

9. **Understand environment differences**

   | Aspect | Production | Development |
   |---|---|---|
   | Filenames | Content-hashed | Matches source names |
   | Minification | Yes | No |
   | Source maps | Yes | No |
   | Static serving | Disabled by default | Enabled |
   | `HANAMI_SERVE_ASSETS` | Set `true` to serve from app | Not needed |

### Using Assets in Views

10. **Get asset URL via helpers**

    ```erb
    <%= asset_url("app.js") %>
    # => "/assets/app-LSLFPUMX.js"

    <%= asset_url("images/logo.png") %>
    # => "/assets/images/logo.png"
    ```

11. **Generate HTML tags for assets**

    ```erb
    <%= javascript_tag("app") %>
    # => <script src="/assets/app-LSLFPUMX.js" type="text/javascript"></script>

    <%= javascript_tag("signin/app") %>
    # => <script src="/assets/signin/app-LSLFPUMX.js" type="text/javascript"></script>

    <%= stylesheet_tag("app") %>
    # => <link rel="stylesheet" href="/assets/app-LSLFPUMX.css">
    ```

12. **Access assets programmatically via the assets component**

    ```ruby
    # In console
    app["assets"]["app.js"].url
    # => "/assets/app-LSLFPUMX.js"

    # In a view part
    context.assets["default-cover-image.jpg"]
    ```

    The assets component is automatically available in the view context.

13. **Inject assets as a dependency**

    ```ruby
    class MyService
      include Deps["assets"]
    end
    ```

### CDN Configuration

14. **Configure a CDN base URL**

    ```ruby
    # config/app.rb
    module Bookshelf
      class App < Hanami::App
        environment :production do
          config.assets.base_url = "https://some-cdn.net/my-site"
        end
      end
    end
    ```

    All asset helpers return absolute URLs prefixed with the CDN:

    ```ruby
    asset_url("app.js")
    # => "https://some-cdn.net/my-site/assets/app-LSLFPUMX.js"
    ```

15. **Update CSP for CDN resources**

    ```ruby
    environment :production do
      config.actions.content_security_policy[:script_src] += " https://some-cdn.net"
      config.actions.content_security_policy[:style_src] += " https://some-cdn.net"
      config.assets.base_url = "https://some-cdn.net/my-site"
    end
    ```

16. **Enable Subresource Integrity (SRI)**

    ```ruby
    environment :production do
      config.assets.subresource_integrity = [:sha256, :sha512]
    end
    ```

    Generates tags with integrity and crossorigin attributes:

    ```html
    <script
      src="/assets/app-LSLFPUMX.js"
      type="text/javascript"
      integrity="sha256-WB2pRuy8LdgAZ0aiFxLN8DdfRjKJTc4P4xuEw31iilM="
      crossorigin="anonymous"
    ></script>
    ```

    Use `:sha256` to start (lighter CPU cost).

### Customization

17. **Customize esbuild options**

    ```javascript
    // config/assets.js
    import * as assets from "hanami-assets";

    await assets.run({
      esbuildOptionsFn: (args, esbuildOptions) => {
        // Modify esbuildOptions here
        return esbuildOptions;
      }
    });
    ```

18. **Apply different options for compile vs watch**

    ```javascript
    await assets.run({
      esbuildOptionsFn: (args, esbuildOptions) => {
        if (args.watch) {
          // Development options
        } else {
          // Production options
        }
        return esbuildOptions;
      }
    });
    ```

19. **Customize slice-level assets**

    Create `slices/<slice_name>/config/assets.js` to override the top-level config for a specific slice.

## Process

When assisting with Hanami Assets tasks, follow this workflow:

1. **Identify the asset needs**
   - Determine what types of assets (JS, CSS, images) are needed
   - Understand if a single bundle or multiple entry points are appropriate
   - Clarify if slice-specific assets are required

2. **Set up entry points**
   - Create entry points under `app/assets/js/` with `app.js` naming
   - Include corresponding CSS files from each entry point
   - Keep entry points focused per-page or per-feature

3. **Guide asset usage in views**
   - Recommend `asset_url` for getting URLs
   - Recommend `javascript_tag` / `stylesheet_tag` for generating HTML
   - Show how to reference static assets (images, fonts) via paths

4. **Address production deployment**
   - Explain `hanami assets compile` for production builds
   - Configure CDN `base_url` when needed
   - Update CSP directives for CDN resources
   - Add SRI when serving from third-party CDNs

5. **Guide customization**
   - Show esbuild customization via `esbuildOptionsFn`
   - Differentiate compile vs watch options using `args.watch`
   - Recommend slice-level config for per-slice customization

6. **Review and refine**
   - Verify only necessary bundles are loaded per page
   - Check CDN configuration and CSP alignment
   - Confirm SRI algorithms match security requirements

## Documentation References

When detailed information is needed about specific topics, consult the Hanami documentation:

- https://guides.hanamirb.org/v2.3/assets/overview/
- https://guides.hanamirb.org/v2.3/assets/using-a-cdn/
- https://guides.hanamirb.org/v2.3/assets/customization/
- https://guides.hanamirb.org/v2.3/helpers/
- https://guides.hanamirb.org/v2.3/commands/assets/

## Constraints

- Always use Hanami v2.x conventions and APIs
- Reference documentation links when providing detailed implementation guidance
- Entry points must be named `app.js` (within a directory under `js/`)
- Only files referenced by an entry point are included in the final bundle
- Use `hanami assets compile` for production, `hanami assets watch` for development
- Content-hashed filenames are production-only; development uses source names
- When using a CDN, always update CSP to allow the CDN origin
- Prefer `:sha256` over `:sha512` for SRI to reduce compilation time
- Slices compile to `public/assets/<slice_name>/` (underscored)
- The `assets` component is only available within the app or slice that owns the assets

## Best Practices

### Entry Point Design
- Create one entry point per page or feature to minimize bundle size
- Keep the default `app.js` for shared/global styles
- Import CSS from JavaScript entry points (Hanami convention)
- Use multiple bundles to improve page loading performance
- Organize entry point directories by feature or page name

### Performance
- Use multiple bundles to load only required assets per page
- Configure CDN for production asset delivery
- Enable SRI when using a CDN for security
- Use `HANAMI_SERVE_ASSETS=true` only when needed (e.g., Docker)
- Minimize esbuild plugin count to keep compilation fast

### Security
- Update CSP directives when adding CDN base_url
- Use SRI with `:sha256` to protect against CDN compromise
- Set secure and httponly flags on cookies separately from assets
- Never rely solely on CDN security; always validate CSP

### Development Workflow
- Use `hanami dev` for combined server + asset watching
- Run `hanami assets compile` before deploying to production
- Verify `public/assets/assets.json` exists after compilation
- Check compiled output in `public/assets/` for debugging
- Update CSP when changing CDN configuration

### Customization
- Use `esbuildOptionsFn` for all esbuild customizations
- Separate compile and watch options using `args.watch`
- Create slice-level `config/assets.js` for per-slice customization
- Avoid modifying esbuild internals directly; use the options object
