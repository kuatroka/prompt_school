<script>
  import { router } from '@inertiajs/svelte'

  let { counter = 0 } = $props()

  let currentCounter = $state(counter)

  async function increment() {
    const response = await fetch('/inertia/counter/increment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
    const data = await response.json()
    currentCounter = data.value
  }

  async function decrement() {
    const response = await fetch('/inertia/counter/decrement', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
    const data = await response.json()
    currentCounter = data.value
  }
</script>

<div class="min-h-screen bg-base-200">
  <!-- Navbar -->
  <div class="navbar bg-base-100 shadow-lg">
    <div class="flex-1">
      <ul class="menu menu-horizontal px-1">
        <li><a href="/" class="text-xl font-bold">Phoenix + Inertia + Svelte 5</a></li>
      </ul>
    </div>
    <div class="flex-none">
      <ul class="menu menu-horizontal px-1">
        <li><a href="/">Home</a></li>
        <li><a href="/demo">LiveView Demo</a></li>
        <li><a href="/inertia/counter">Inertia Counter</a></li>
      </ul>
    </div>
  </div>

  <div class="container mx-auto p-8">
    <h1 class="text-4xl font-bold mb-8 text-center">Inertia + Svelte 5 Counter</h1>

    <div class="card bg-base-100 shadow-xl mb-8">
      <div class="card-body">
        <h2 class="card-title">Interactive Counter (Inertia + Svelte 5)</h2>
        <p class="text-sm text-gray-600 mb-4">Using Svelte 5 runes ($state, $props) with Inertia.js</p>
        <p class="text-2xl font-bold text-center my-4">Count: {currentCounter}</p>
        <div class="card-actions justify-center gap-4">
          <button class="btn btn-primary" onclick={increment}>
            Increment
          </button>
          <button class="btn btn-secondary" onclick={decrement}>
            Decrement
          </button>
        </div>
      </div>
    </div>

    <div class="alert alert-info">
      <span>
        This counter uses the same SQLite database as the LiveView demo.
        Changes persist across page refreshes and server restarts.
      </span>
    </div>
  </div>
</div>
