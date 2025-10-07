# Testing the Vite Setup

## Quick Test

To verify the Vite setup is working correctly:

### 1. Start the Development Server

```bash
mix phx.server
```

You should see:
- Phoenix starting on port 4000
- Vite dev server starting on port 5173
- No errors in the console

### 2. Test LiveView Page

Visit: http://localhost:4000/demo

You should see:
- A styled page with Tailwind CSS and DaisyUI
- A counter that increments/decrements
- Changes persist in the database

### 3. Test Inertia + Svelte Page

Visit: http://localhost:4000/inertia/counter

You should see:
- A Svelte 5 component rendered
- A counter with increment/decrement buttons
- Smooth interactions without page reloads

### 4. Test Hot Module Replacement (HMR)

With the server running:

1. Open `assets/svelte/Counter.svelte`
2. Change the title text
3. Save the file
4. The browser should update **without a full page reload**

### 5. Test Production Build

```bash
mix assets.deploy
```

You should see:
- Vite building assets
- Output files in `priv/static/assets/`
- A manifest file at `priv/static/.vite/manifest.json`

### 6. Verify Asset Fingerprinting

Check the manifest:

```bash
cat priv/static/.vite/manifest.json
```

You should see fingerprinted asset names like:
- `app-[hash].js`
- `app-[hash].css`
- `Counter-[hash].js`

## Expected Console Output

### Development Server Start

```
[info] Running PhxLiveTailwindDaisyWeb.Endpoint with Bandit 1.8.0 at 127.0.0.1:4000 (http)
[info] Access PhxLiveTailwindDaisyWeb.Endpoint at http://localhost:4000

  VITE v6.3.6  ready in 234 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

### Production Build

```
vite v6.3.6 building for production...
✓ 864 modules transformed.
rendering chunks...
computing gzip size...
../priv/static/.vite/manifest.json           0.60 kB │ gzip:  0.22 kB
../priv/static/assets/app-[hash].css        73.71 kB │ gzip: 12.88 kB
../priv/static/assets/Counter-[hash].js      2.13 kB │ gzip:  0.99 kB
../priv/static/assets/app-[hash].js        299.99 kB │ gzip: 98.95 kB
✓ built in 1.34s
```

## Troubleshooting

### Port 5173 Already in Use

Kill the process:
```bash
lsof -ti:5173 | xargs kill -9
```

### Assets Not Loading

1. Check Vite is running: `curl http://localhost:5173`
2. Check Phoenix config: `config/dev.exs` should have `static_url: [host: "localhost", port: 5173]`
3. Restart Phoenix: `mix phx.server`

### Svelte Component Not Rendering

1. Check browser console for errors
2. Verify component is registered in `assets/js/app.js`
3. Check Inertia is properly configured in router

## Success Criteria

✅ Phoenix starts without errors
✅ Vite dev server starts on port 5173
✅ LiveView page loads with Tailwind styling
✅ Inertia page loads with Svelte component
✅ HMR works (changes reflect without reload)
✅ Production build completes successfully
✅ Assets are fingerprinted in production

If all criteria pass, your Vite setup is working correctly! 🎉
