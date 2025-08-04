<script>
  export let count = 0;
  export let pushEvent;

  function increment() {
    pushEvent("increment", {});
  }

  function decrement() {
    pushEvent("decrement", {});
  }
</script>

<div class="flex flex-col items-center space-y-4 p-6 bg-white rounded-lg shadow-lg">
  <h2 class="text-2xl font-bold text-gray-800">Counter</h2>
  <div class="text-4xl font-mono text-blue-600">{count}</div>
  <div class="flex space-x-4">
    <button 
      on:click={decrement}
      class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
    >
      -
    </button>
    <button 
      on:click={increment}
      class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
    >
      +
    </button>
  </div>
</div>
