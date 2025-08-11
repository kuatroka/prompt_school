<script>
  // Using LiveSvelte pattern with 'live' prop
  export let count = 0;
  export let live;
  
  function increment() {
    live.pushEvent("increment", {}, () => {});
  }
  
  function decrement() {
    live.pushEvent("decrement", {}, () => {});
  }
  
  function reset() {
    live.pushEvent("reset", {}, () => {});
  }
</script>

<div class="card w-96 bg-base-100 shadow-xl border border-base-300">
  <div class="card-body">
    <h2 class="card-title text-2xl">Svelte Counter</h2>
    <div class="stats bg-base-200 my-4">
      <div class="stat">
        <div class="stat-title">Current Count</div>
        <div class="stat-value text-primary font-mono">{count}</div>
        <div class="stat-desc">Phoenix + LiveView + Svelte</div>
      </div>
    </div>
    <div class="card-actions justify-center gap-2">
      <button class="btn btn-error" on:click={decrement}>
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path>
        </svg>
        Decrement
      </button>
      <button class="btn btn-secondary" on:click={reset}>
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
        </svg>
        Reset
      </button>
      <button class="btn btn-success" on:click={increment}>
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
        </svg>
        Increment
      </button>
    </div>
  </div>
</div>