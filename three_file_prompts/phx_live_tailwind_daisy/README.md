# PhxLiveTailwindDaisy

A modern Phoenix 1.8 application with:
- **Phoenix LiveView** for real-time server-rendered UI
- **Inertia.js + Svelte 5** for SPA-like experiences
- **Vite** for lightning-fast frontend builds with HMR
- **Tailwind CSS v4** for utility-first styling
- **DaisyUI** for beautiful component classes
- **SQLite** for simple, file-based database
- **Bun** for fast package management

## Tech Stack

### Backend
- Phoenix 1.8.1
- Elixir 1.15+
- Ecto with SQLite adapter

### Frontend
- Vite 6.3+ (replaces ESBuild)
- Svelte 5.0 with runes
- Inertia.js 2.2+
- Tailwind CSS 4.1+
- DaisyUI 5.1+

## Getting Started

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit:
- [`localhost:4000`](http://localhost:4000) - Home page
- [`localhost:4000/demo`](http://localhost:4000/demo) - LiveView demo
- [`localhost:4000/inertia/counter`](http://localhost:4000/inertia/counter) - Inertia + Svelte demo

## Development

### Vite Dev Server

When you run `mix phx.server`, Vite automatically starts on port 5173 and provides:
- Hot Module Replacement (HMR) for instant updates
- Fast builds with on-demand compilation
- Automatic CSS injection

### Asset Pipeline

- **Development**: Vite dev server on port 5173 with HMR
- **Production**: `mix assets.deploy` builds optimized bundles

### Project Structure

```
assets/
├── css/
│   └── app.css          # Tailwind CSS v4 with DaisyUI
├── js/
│   └── app.js           # Main entry point (Phoenix + Inertia)
├── svelte/
│   └── Counter.svelte   # Svelte 5 components
├── vite.config.mjs      # Vite configuration
└── package.json         # Frontend dependencies
```

## Key Features

### Vite Integration

This project uses `phoenix_vite` for seamless Vite integration:
- Automatic dev server startup
- HMR for Svelte components
- Optimized production builds
- Asset fingerprinting

### Svelte 5 Runes

Components use modern Svelte 5 syntax:
```svelte
<script>
  let { counter = 0 } = $props()
  let currentCounter = $state(counter)
</script>
```

### Hybrid Approach

Mix and match LiveView and Inertia:
- Use LiveView for real-time features
- Use Inertia + Svelte for rich client interactions
- Share the same database and backend logic

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
