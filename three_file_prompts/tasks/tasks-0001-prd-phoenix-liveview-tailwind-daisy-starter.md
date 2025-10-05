# Task List: Phoenix LiveView + Tailwind CSS v4 + DaisyUI Starter Template

## Relevant Files

### Core Configuration Files
- `mix.exs` - Project dependencies including Phoenix, LiveView, Ecto, SQLite adapter, and test dependencies
- `config/config.exs` - Base application configuration
- `config/dev.exs` - Development environment config including SQLite database path, watchers for Bun-based asset compilation
- `config/test.exs` - Test environment config with SQLite test database settings
- `config/prod.exs` - Production configuration for SQLite and asset compilation
- `config/runtime.exs` - Runtime configuration for database paths and secret management

### Application Core
- `lib/[app_name]/application.ex` - Application supervisor configuration
- `lib/[app_name]/repo.ex` - Ecto repository module configured for SQLite
- `lib/[app_name]_web/endpoint.ex` - Phoenix endpoint with LiveView socket configuration
- `lib/[app_name]_web/router.ex` - Application routes including demo LiveView page route
- `lib/[app_name]_web/telemetry.ex` - Telemetry setup for monitoring

### Layout and Components
- `lib/[app_name]_web/components/layouts.ex` - Layout components module
- `lib/[app_name]_web/components/layouts/root.html.heex` - Root HTML layout with Tailwind CSS links
- `lib/[app_name]_web/components/layouts/app.html.heex` - Application layout with navigation
- `lib/[app_name]_web/components/core_components.ex` - Core reusable components

### Demo LiveView
- `lib/[app_name]_web/live/demo_live.ex` - Main demo LiveView module with interactive features
- `lib/[app_name]_web/live/demo_live.html.heex` - Demo page template showcasing DaisyUI components
- `test/[app_name]_web/live/demo_live_test.exs` - Unit tests for demo LiveView functionality

### Assets and Styling
- `assets/package.json` - Bun package manifest with Tailwind CSS v4 and DaisyUI dependencies
- `assets/bun.lockb` - Bun lock file
- `assets/js/app.js` - Main JavaScript entry point
- `assets/css/app.css` - Main CSS file with Tailwind directives (@tailwind base, components, utilities)
- `assets/tailwind.config.js` - Tailwind CSS configuration with DaisyUI plugin
- `assets/vendor/topbar.js` - Progress bar for LiveView navigation

### Build and Asset Pipeline
- `priv/static/` - Compiled static assets directory
- `.esbuild` - ESBuild configuration
- `esbuild.config.js` - Custom ESBuild configuration if needed

### Testing
- `test/test_helper.exs` - Test configuration and setup
- `test/support/conn_case.ex` - Test case helpers for controller/view tests
- `test/support/data_case.ex` - Test case helpers for Ecto/database tests

### Deployment and Infrastructure
- `Dockerfile` - Docker container configuration for deployment
- `fly.toml` - Fly.io deployment configuration
- `.dockerignore` - Docker ignore patterns
- `rel/overlays/bin/server` - Release server script
- `rel/overlays/bin/server.bat` - Windows release server script

### Documentation and Project Files
- `README.md` - Comprehensive setup instructions, technology versions, and project overview
- `.gitignore` - Git ignore patterns including node_modules, SQLite files, build artifacts
- `.formatter.exs` - Elixir code formatter configuration

### Notes
- Replace `[app_name]` with your actual application name throughout the codebase
- SQLite database files will be stored in `priv/` directory (e.g., `priv/dev.db`, `priv/test.db`)
- Run tests with `mix test` or `mix test test/path/to/specific_test.exs`
- Use `mix phx.server` to start the development server
- Asset compilation will be handled by Bun via Phoenix watchers configured in `config/dev.exs`

## Tasks

- [ ] 1.0 Generate Phoenix application with LiveView and configure initial project structure
  - [x] 1.1 Verify Elixir (>= 1.14) and Erlang (>= 25) versions are installed
  - [x] 1.2 Install latest Phoenix framework (`mix archive.install hex phx_new`)
  - [x] 1.3 Generate new Phoenix app with LiveView (`mix phx.new [app_name] --live`)
  - [x] 1.4 Review generated project structure and verify all default files are present
  - [x] 1.5 Initialize git repository (`git init`) and make initial commit
  - [x] 1.6 Update `.gitignore` to exclude SQLite database files (`*.db`, `*.db-*`)

- [ ] 2.0 Configure SQLite database adapter and set up Ecto
  - [ ] 2.1 Add `ecto_sqlite3` dependency to `mix.exs` (replace postgrex if present)
  - [ ] 2.2 Update `lib/[app_name]/repo.ex` to use `Ecto.Adapters.SQLite3`
  - [ ] 2.3 Configure development database in `config/dev.exs` with SQLite file path (e.g., `database: "priv/dev.db"`)
  - [ ] 2.4 Configure test database in `config/test.exs` with SQLite file path (e.g., `database: "priv/test.db"`)
  - [ ] 2.5 Configure production database in `config/runtime.exs` for SQLite
  - [ ] 2.6 Run `mix deps.get` to fetch new dependencies
  - [ ] 2.7 Create database with `mix ecto.create`
  - [ ] 2.8 Verify database connection with `mix ecto.migrate` (should run successfully even with no migrations)
  - [ ] 2.9 Test database operations by creating a simple schema and running basic CRUD operations

- [ ] 3.0 Integrate Bun as package manager and configure asset pipeline
  - [ ] 3.1 Verify Bun is installed globally (`bun --version`) or install it
  - [ ] 3.2 Navigate to `assets/` directory and remove existing `package-lock.json` or `yarn.lock` if present
  - [ ] 3.3 Run `bun install` in assets directory to install existing dependencies
  - [ ] 3.4 Update `config/dev.exs` watchers configuration to use `bun` instead of `npm` or `yarn`
  - [ ] 3.5 Update any build scripts in `assets/package.json` to be compatible with Bun
  - [ ] 3.6 Configure esbuild to work with Bun's module resolution
  - [ ] 3.7 Test asset compilation by starting Phoenix server (`mix phx.server`) and verify assets load correctly
  - [ ] 3.8 Verify hot reloading works for JavaScript changes in `assets/js/`

- [ ] 4.0 Install and configure Tailwind CSS v4 and DaisyUI
  - [ ] 4.1 Navigate to `assets/` directory
  - [ ] 4.2 Install Tailwind CSS v4 using Bun (`bun add -D tailwindcss@next`)
  - [ ] 4.3 Install DaisyUI using Bun (`bun add -D daisyui`)
  - [ ] 4.4 Generate Tailwind config file (`bunx tailwindcss init`)
  - [ ] 4.5 Configure `assets/tailwind.config.js` with content paths for Phoenix templates (e.g., `../lib/**/*.{ex,exs,heex}`)
  - [ ] 4.6 Add DaisyUI plugin to `tailwind.config.js` plugins array
  - [ ] 4.7 Update `assets/css/app.css` to include Tailwind directives (`@tailwind base;`, `@tailwind components;`, `@tailwind utilities;`)
  - [ ] 4.8 Configure Tailwind build process in `assets/package.json` scripts
  - [ ] 4.9 Update `config/dev.exs` to add Tailwind watcher using Bun
  - [ ] 4.10 Test Tailwind compilation by adding utility class to any template and verifying styles appear
  - [ ] 4.11 Test DaisyUI by adding a DaisyUI button class (e.g., `btn btn-primary`) and verifying component styles

- [ ] 5.0 Create demo LiveView page showcasing Tailwind CSS and DaisyUI components
  - [ ] 5.1 Create `lib/[app_name]_web/live/demo_live.ex` LiveView module
  - [ ] 5.2 Add basic LiveView mount function and initial state (e.g., counter, form data)
  - [ ] 5.3 Create `lib/[app_name]_web/live/demo_live.html.heex` template file
  - [ ] 5.4 Add DaisyUI navbar component to template
  - [ ] 5.5 Add DaisyUI card components showcasing different styles
  - [ ] 5.6 Add DaisyUI button components (primary, secondary, accent) with LiveView click handlers
  - [ ] 5.7 Implement interactive counter using LiveView events (increment/decrement buttons)
  - [ ] 5.8 Add DaisyUI form components (inputs, textareas) with LiveView form handling
  - [ ] 5.9 Add DaisyUI modal component triggered by LiveView event
  - [ ] 5.10 Style layout with Tailwind utility classes (flexbox, grid, spacing, colors)
  - [ ] 5.11 Add route for demo page in `lib/[app_name]_web/router.ex` (e.g., `live "/demo", DemoLive`)
  - [ ] 5.12 Test demo page in browser at `/demo` and verify all interactive features work
  - [ ] 5.13 Verify WebSocket connection is stable and LiveView updates work in real-time

- [ ] 6.0 Set up testing, deployment configuration, and documentation
  - [ ] 6.1 Verify ExUnit is configured in `test/test_helper.exs`
  - [ ] 6.2 Create `test/[app_name]_web/live/demo_live_test.exs` with basic tests
  - [ ] 6.3 Add test for demo LiveView mount and initial render
  - [ ] 6.4 Add test for interactive features (button clicks, form submissions)
  - [ ] 6.5 Run `mix test` and ensure all tests pass
  - [ ] 6.6 Create `Dockerfile` for containerized deployment
  - [ ] 6.7 Create `fly.toml` for Fly.io deployment (or alternative platform config)
  - [ ] 6.8 Create `.dockerignore` file
  - [ ] 6.9 Write comprehensive `README.md` with project overview
  - [ ] 6.10 Document setup instructions in README (prerequisites, installation steps, running dev server)
  - [ ] 6.11 Document all technology versions in README (Phoenix, Elixir, Erlang, Bun, Tailwind v4, DaisyUI)
  - [ ] 6.12 Add project structure overview to README explaining key directories
  - [ ] 6.13 Add troubleshooting section to README for common issues
  - [ ] 6.14 Test complete setup process on clean environment (or document what would be needed)
  - [ ] 6.15 Create final git commit with all changes and tag as v1.0.0
