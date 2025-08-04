defmodule PhxLiveSvelteFreWeb.CounterLive do
  use PhxLiveSvelteFreWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  @impl true
  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  @impl true
  def handle_event("decrement", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count - 1)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-100 flex items-center justify-center">
      <div class="flex flex-col items-center space-y-4 p-6 bg-white rounded-lg shadow-lg">
        <h2 class="text-2xl font-bold text-gray-800">Counter</h2>
        <div class="text-4xl font-mono text-blue-600"><%= @count %></div>
        <div class="flex space-x-4">
          <button 
            phx-click="decrement"
            class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
          >
            -
          </button>
          <button 
            phx-click="increment"
            class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
          >
            +
          </button>
        </div>
      </div>
    </div>
    """
  end
end
