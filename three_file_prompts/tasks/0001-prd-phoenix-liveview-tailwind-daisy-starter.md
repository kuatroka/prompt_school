# Product Requirements Document: Phoenix LiveView + Tailwind CSS v4 + DaisyUI Starter Template

## Introduction/Overview

This feature involves creating a reusable starter template for Phoenix applications that includes the latest versions of Phoenix, Phoenix LiveView, Tailwind CSS v4, and DaisyUI. The template will serve as a foundation for future Phoenix projects, providing a pre-configured development environment with modern styling frameworks and SQLite database integration.

**Problem:** Setting up a new Phoenix project with modern frontend tooling (Tailwind CSS v4, DaisyUI) requires manual configuration and integration steps that are time-consuming and error-prone.

**Goal:** Create a fully-configured, reusable Phoenix starter template that can be cloned and used immediately for new projects, eliminating repetitive setup work.

## Goals

1. Provide a working Phoenix application with LiveView configured and ready to use
2. Integrate Tailwind CSS v4 with proper build pipeline configuration
3. Include DaisyUI components library fully configured and functional
4. Use SQLite as the database for simplicity and portability
5. Configure Bun as the JavaScript package manager and runtime
6. Include sample/demo pages demonstrating the stack integration
7. Ensure development server runs smoothly with hot reloading
8. Provide a foundation that can be used for multiple future projects

## User Stories

1. **As a developer**, I want to clone a starter template so that I can begin building Phoenix applications without manual setup.

2. **As a developer**, I want Tailwind CSS v4 pre-configured so that I can use modern utility classes immediately.

3. **As a developer**, I want DaisyUI components available so that I can build UI quickly using pre-styled components.

4. **As a developer**, I want LiveView working out of the box so that I can create interactive features without writing JavaScript.

5. **As a developer**, I want to see working examples so that I understand how all the technologies integrate together.

6. **As a developer**, I want SQLite configured so that I can develop locally without needing to set up PostgreSQL.

7. **As a developer**, I want Bun as the package manager so that I benefit from faster installation and build times.

## Functional Requirements

1. The system must generate a new Phoenix application using the latest stable version of Phoenix.

2. The system must install and configure Phoenix LiveView to the latest version.

3. The system must integrate Tailwind CSS version 4 with proper configuration files and build pipeline.

4. The system must install and configure DaisyUI as a Tailwind CSS plugin.

5. The system must configure Bun as the JavaScript package manager and runtime.

6. The system must configure SQLite as the database adapter in the Phoenix application.

7. The system must create database configuration files appropriate for SQLite (dev, test, prod environments).

8. The system must set up the development server to run with hot reloading for both Elixir and asset changes.

9. The system must create at least one sample LiveView page demonstrating:
   - Tailwind CSS v4 utility classes working correctly
   - DaisyUI components rendering properly
   - LiveView interactivity (e.g., button clicks, form handling, real-time updates)

10. The system must include testing setup with ExUnit configured.

11. The system must include deployment configuration files (e.g., Dockerfile, fly.toml, or similar).

12. The system must verify all dependencies install correctly using Bun.

13. The system must include a README documenting:
    - How to clone and set up the template
    - How to start the development server
    - Technologies included and their versions
    - Project structure overview

14. The system must ensure all asset compilation (CSS, JS) works correctly with Bun.

15. The system must configure watchers for automatic asset recompilation during development.

## Non-Goals (Out of Scope)

1. **Production deployment configuration** - While deployment configuration files may be included, actual production deployment processes, hosting setup, and production optimizations are out of scope.

2. **CI/CD pipelines** - No GitHub Actions, GitLab CI, or other continuous integration/deployment workflows will be configured.

3. **Authentication/Authorization** - No user authentication systems, login flows, or authorization logic will be implemented.

4. **Business logic** - No domain-specific features or business logic will be included beyond basic demonstration examples.

5. **Production-ready database migrations** - Only basic database setup for development purposes will be included.

6. **Advanced deployment strategies** - Blue-green deployments, canary releases, or complex deployment patterns are not included.

7. **Monitoring and logging infrastructure** - No production monitoring, APM tools, or centralized logging setup.

8. **Security hardening** - Beyond Phoenix defaults, no additional security measures or security audits.

## Design Considerations

1. **Sample Page UI**: The demo page should showcase common DaisyUI components including:
   - Buttons (primary, secondary, accent styles)
   - Cards
   - Forms with inputs
   - Navigation bar
   - At least one modal or interactive component driven by LiveView

2. **File Structure**: Follow standard Phoenix conventions for directory structure.

3. **Styling Architecture**: Use Tailwind CSS v4's new configuration approach (if different from v3), ensuring compatibility with DaisyUI.

4. **Component Organization**: LiveView components should be organized in a clear, scalable manner.

## Technical Considerations

1. **Bun Integration**: Ensure Phoenix's asset pipeline is configured to use Bun instead of npm/yarn. This may require custom configuration in `config/dev.exs` and potentially modifying the esbuild setup.

2. **Tailwind CSS v4**: As Tailwind v4 may have breaking changes from v3, ensure the configuration uses the latest syntax and features.

3. **SQLite Configuration**: Configure Ecto to use the SQLite adapter (`ecto_sqlite3`). Ensure proper file paths for database files in different environments.

4. **LiveView Socket Configuration**: Ensure WebSocket connections are properly configured for LiveView.

5. **Asset Pipeline**: Verify that CSS and JavaScript assets are properly built and served during development and can be prepared for production.

6. **Dependencies**: Key dependencies to include:
   - `phoenix` (latest)
   - `phoenix_live_view` (latest)
   - `ecto_sqlite3` (latest)
   - Tailwind CSS v4 (via CDN or standalone CLI)
   - DaisyUI (via Bun)

7. **Elixir/Erlang Versions**: Document the required Elixir and Erlang versions for compatibility.

## Success Metrics

1. **Development server runs without errors**: Running `mix phx.server` successfully starts the application on localhost without compilation or runtime errors.

2. **Tailwind CSS v4 styles are applied correctly**: Tailwind utility classes render with the correct styles on demo pages, and the Tailwind build process works correctly.

3. **DaisyUI components render properly**: DaisyUI component classes produce the expected styled components with proper theming.

4. **LiveView features work correctly**: Interactive LiveView features (buttons, forms, real-time updates) function without errors and WebSocket connections are stable.

5. **All tests pass**: Running `mix test` executes successfully with all default tests passing.

6. **Assets compile correctly**: CSS and JavaScript assets compile and rebuild automatically during development when files change.

7. **Database operations work**: Basic database operations (create, read, update, delete) work correctly with SQLite.

## Open Questions

1. Should the template include a specific DaisyUI theme configuration, or use the default theme?

2. Should Docker configuration be included for development environment consistency?

3. What level of testing examples should be included (basic smoke tests only, or more comprehensive examples)?

4. Should the template include any specific Elixir code formatting or linting tools (e.g., `mix format`, Credo)?

5. Should we include any specific VS Code or editor configurations for a better development experience?

6. For deployment configuration, which platform should be prioritized (Fly.io, Render, AWS, generic Docker)?
