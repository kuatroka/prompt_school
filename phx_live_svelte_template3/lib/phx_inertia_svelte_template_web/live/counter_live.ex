defmodule PhxInertiaSvelteTemplateWeb.CounterLive do
  use PhxInertiaSvelteTemplateWeb, :live_view

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
  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, count: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="hero min-h-[70vh]">
      <div class="hero-content text-center">
        <div class="max-w-lg">
          <h1 class="text-5xl font-bold mb-4 bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
            Phoenix + LiveSvelte
          </h1>
          <p class="text-lg mb-8 opacity-80">
            A seamless integration of Phoenix LiveView with Svelte components, styled with DaisyUI and Tailwind 4.
          </p>
          
          <div class="flex justify-center mb-8">
            <.svelte 
              name="Counter" 
              props={%{count: @count}} 
              socket={@socket} 
            />
          </div>
          
          <div class="alert alert-info shadow-lg">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <div>
              <div class="font-bold">Real-time Updates</div>
              <div class="text-sm">The counter state is managed by Phoenix LiveView and rendered by a Svelte component!</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end