# Vite Setup Documentation

This document describes the Phoenix + Inertia + Svelte 5 + Vite setup implemented in this project.

## Overview

This project successfully migrated from ESBuild to Vite, providing:
- **Hot Module Replacement (HMR)** for instant feedback during development
- **Faster builds** with on-demand compilation
- **Better DX** with Vite's modern tooling
- **First-class Svelte 5 support** with proper HMR

## Architecture

### Development Mode
```
Phoenix (port 4000) ──┐
                      ├──> Vite Dev Server (port 5173)
                      │    ├── HMR WebSocket
                      │    ├── Svelte Plugin
                      │    ├── Tailwind Plugin
                      │    └── Phoenix Plugin
                      │
                      └──> Phoenix LiveView
```

### Production Mode
```
Phoenix (port 4000) ──> Static Assets (priv/static)
                        └── Vite Manifest (.vite/manifest.json)
```

## Key Files

### 1. mix.exs
**Added dependencies:**
- `{:phoenix_vite, "~> 0.1"}` - Phoenix-Vite integration
- `{:bun, "~> 1.5", runtime: Mix.env() == :dev}` - Bun for package management

**Removed dependencies:**
- `{:esbuild, ...}` - No longer needed
- `{:tailwind, ...}` - Handled by Vite now

**Updated aliases:**
```elixir
"assets.setup": ["bun.install --if-missing", "cmd --cd assets bun install"],
"assets.build": ["cmd --cd assets bun vite build"],
"assets.deploy": ["cmd --cd assets bun vite build", "phx.digest"]
```

### 2. assets/vite.config.mjs
```javascript
import { defineConfig } from 'vite'
import { phoenixVitePlugin } from 'phoenix_vite'
import tailwindcss from '@tailwindcss/vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

export default defineConfig({
  server: {
    port: 5173,
    strictPort: true,
    cors: { origin: 'http://localhost:4000' }
  },
  
  optimizeDeps: {
    include: ['phoenix', 'phoenix_html', 'phoenix_live_view']
  },
  
  build: {
    manifest: true,
    rollupOptions: {
      input: ['js/app.js', 'css/app.css']
    },
    outDir: '../priv/static',
    emptyOutDir: true
  },
  
  plugins: [
    svelte(),
    tailwindcss(),
    phoenixVitePlugin({ pattern: /\.(ex|heex)$/ })
  ]
})
```

### 3. assets/package.json
**Key changes:**
- Added `vite`, `@sveltejs/vite-plugin-svelte`, `@tailwindcss/vite`
- Added `phoenix_vite` as file dependency
- Removed `esbuild-svelte`
- Updated scripts to use Vite

### 4. config/dev.exs
**Watcher configuration:**
```elixir
watchers: [
  vite: {Bun, :install_and_run, [:vite, ~w(dev)]}
],
static_url: [host: "localhost", port: 5173]
```

### 5. config/config.exs
**Removed:**
- ESBuild configuration
- Tailwind configuration

### 6. config/prod.exs
**Added:**
```elixir
cache_static_manifest_latest:
  PhoenixVite.cache_static_manifest_latest(:phx_live_tailwind_daisy)
```

### 7. Layout Templates
**Updated both:**
- `lib/phx_live_tailwind_daisy_web/components/layouts/root.html.heex`
- `lib/phx_live_tailwind_daisy_web/controllers/inertia_html/root.html.heex`

**From:**
```heex
<link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

**To:**
```heex
<PhoenixVite.Components.assets
  names={["js/app.js", "css/app.css"]}
  manifest={{:phx_live_tailwind_daisy, "priv/static/.vite/manifest.json"}}
  dev_server={PhoenixVite.Components.has_vite_watcher?(PhxLiveTailwindDaisyWeb.Endpoint)}
  to_url={fn p -> static_url(PhxLiveTailwindDaisyWeb.Endpoint, p) end}
/>
```

### 8. assets/js/app.js
**Added:**
```javascript
import "../css/app.css"
import topbar from "topbar"
```

## How It Works

### Development Workflow

1. **Start Phoenix**: `mix phx.server`
2. **Vite starts automatically** via the watcher configuration
3. **Vite dev server** runs on port 5173
4. **Phoenix templates** reference assets from Vite dev server
5. **HMR** updates browser instantly on file changes

### Asset Resolution

**Development:**
- `PhoenixVite.Components.assets` detects Vite watcher is running
- Assets are loaded from `http://localhost:5173/@vite/client` and `http://localhost:5173/js/app.js`
- Vite provides HMR via WebSocket

**Production:**
- `PhoenixVite.Components.assets` reads `.vite/manifest.json`
- Assets are loaded from `priv/static/assets/` with fingerprinted names
- No Vite dev server needed

### Svelte 5 Integration

**Automatic Runes Detection:**
- Svelte 5 automatically detects runes usage per-component
- Components using `$state`, `$props`, etc. are compiled in runes mode
- Other components (like Inertia's internal components) use legacy mode
- No global configuration needed

**Example Component:**
```svelte
<script>
  let { counter = 0 } = $props()
  let currentCounter = $state(counter)
  
  function increment() {
    currentCounter++
  }
</script>

<button onclick={increment}>
  Count: {currentCounter}
</button>
```

## Benefits Over ESBuild

### 1. Hot Module Replacement (HMR)
- **ESBuild**: Full page reload on changes
- **Vite**: Module-level updates without page reload

### 2. Development Speed
- **ESBuild**: Rebuilds entire bundle on changes
- **Vite**: On-demand compilation, only builds what's needed

### 3. Plugin Ecosystem
- **ESBuild**: Limited plugins
- **Vite**: Rich ecosystem (Svelte, Tailwind, etc.)

### 4. Framework Support
- **ESBuild**: Basic support via plugins
- **Vite**: First-class support for Svelte, React, Vue

### 5. Developer Experience
- **ESBuild**: Basic error messages
- **Vite**: Rich error overlay with source maps

## Troubleshooting

### Vite dev server not starting
- Check if port 5173 is available
- Verify `watchers` configuration in `config/dev.exs`
- Check Bun is installed: `bun --version`

### Assets not loading in development
- Verify `static_url` is set to `[host: "localhost", port: 5173]`
- Check Vite dev server is running: `curl http://localhost:5173`
- Verify `PhoenixVite.Components.has_vite_watcher?/1` returns true

### Build errors
- Run `cd assets && bun install` to ensure dependencies are up to date
- Check `vite.config.mjs` for syntax errors
- Verify all imports in `app.js` are correct

### Svelte component errors
- Ensure Svelte 5 syntax is used correctly
- Check for deprecated `on:` directives (use `onclick` instead)
- Verify component imports in `app.js`

## Migration Checklist

If migrating an existing Phoenix project to Vite:

- [ ] Add `phoenix_vite` and `bun` to `mix.exs`
- [ ] Remove `esbuild` and `tailwind` from `mix.exs`
- [ ] Create `assets/vite.config.mjs`
- [ ] Update `assets/package.json` with Vite dependencies
- [ ] Update `config/dev.exs` watcher and static_url
- [ ] Remove ESBuild/Tailwind config from `config/config.exs`
- [ ] Update layout templates to use `PhoenixVite.Components.assets`
- [ ] Add CSS import to `assets/js/app.js`
- [ ] Update `config/prod.exs` with Vite manifest config
- [ ] Delete old build scripts (e.g., `build.js`)
- [ ] Run `mix deps.get && cd assets && bun install`
- [ ] Test development: `mix phx.server`
- [ ] Test production build: `mix assets.deploy`

## Resources

- [Vite Documentation](https://vite.dev/)
- [phoenix_vite on Hex](https://hex.pm/packages/phoenix_vite)
- [Svelte 5 Documentation](https://svelte.dev/docs/svelte/overview)
- [Inertia.js Documentation](https://inertiajs.com/)
- [Tailwind CSS v4](https://tailwindcss.com/docs)
