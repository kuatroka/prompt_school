import { defineConfig } from 'vite'
import { phoenixVitePlugin } from 'phoenix_vite'
import tailwindcss from '@tailwindcss/vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

export default defineConfig({
  server: {
    port: 5173,
    strictPort: true,
    cors: {
      origin: 'http://localhost:4000'
    }
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

  resolve: {
    alias: {
      '@': '.',
      'phoenix-colocated': `${process.env.MIX_BUILD_PATH}/phoenix-colocated`
    }
  },

  plugins: [
    svelte(),
    tailwindcss(),
    phoenixVitePlugin({ pattern: /\.(ex|heex)$/ })
  ]
})
