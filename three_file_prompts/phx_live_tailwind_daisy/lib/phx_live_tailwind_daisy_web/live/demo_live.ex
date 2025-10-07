defmodule PhxLiveTailwindDaisyWeb.DemoLive do
  use PhxLiveTailwindDaisyWeb, :live_view

  alias PhxLiveTailwindDaisy.{Repo, Counter}

  @impl true
  def mount(_params, _session, socket) do
    # Get or create the counter from database
    counter = case Repo.get(Counter, 1) do
      nil ->
        %Counter{id: 1, value: 0}
        |> Repo.insert!()
      existing_counter ->
        existing_counter
    end

    {:ok,
     socket
     |> assign(:counter, counter.value)
     |> assign(:show_modal, false)
     |> assign(:form_name, "")
     |> assign(:form_message, "")}
  end

  @impl true
  def handle_event("increment", _, socket) do
    counter = Repo.get!(Counter, 1)
    new_value = counter.value + 1

    counter
    |> Counter.changeset(%{value: new_value})
    |> Repo.update!()

    {:noreply, assign(socket, :counter, new_value)}
  end

  @impl true
  def handle_event("decrement", _, socket) do
    counter = Repo.get!(Counter, 1)
    new_value = counter.value - 1

    counter
    |> Counter.changeset(%{value: new_value})
    |> Repo.update!()

    {:noreply, assign(socket, :counter, new_value)}
  end

  @impl true
  def handle_event("toggle_modal", _, socket) do
    {:noreply, assign(socket, :show_modal, !socket.assigns.show_modal)}
  end

  @impl true
  def handle_event("submit_form", %{"name" => name, "message" => message}, socket) do
    {:noreply,
     socket
     |> assign(:form_name, name)
     |> assign(:form_message, message)
     |> put_flash(:info, "Form submitted successfully!")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-200">
      <!-- Navbar -->
      <div class="navbar bg-base-100 shadow-lg">
        <div class="flex-1">
          <ul class="menu menu-horizontal px-1">
            <li><a class="text-xl font-bold">Phoenix + Tailwind + DaisyUI</a></li>
          </ul>
        </div>
        <div class="flex-none">
          <ul class="menu menu-horizontal px-1">
            <li><a>Home</a></li>
            <li><a>About</a></li>
            <li><a>Contact</a></li>
          </ul>
        </div>
      </div>

      <div class="container mx-auto p-8">
        <h1 class="text-4xl font-bold mb-8 text-center">Demo LiveView Page</h1>

        <!-- Cards Section -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
              <h2 class="card-title">Primary Card</h2>
              <p>This is a primary styled card component from DaisyUI.</p>
              <div class="card-actions justify-end">
                <button class="btn btn-primary">Action</button>
              </div>
            </div>
          </div>

          <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
              <h2 class="card-title">Secondary Card</h2>
              <p>This is a secondary styled card component from DaisyUI.</p>
              <div class="card-actions justify-end">
                <button class="btn btn-secondary">Action</button>
              </div>
            </div>
          </div>

          <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
              <h2 class="card-title">Accent Card</h2>
              <p>This is an accent styled card component from DaisyUI.</p>
              <div class="card-actions justify-end">
                <button class="btn btn-accent">Action</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Interactive Counter Section -->
        <div class="card bg-base-100 shadow-xl mb-8">
          <div class="card-body">
            <h2 class="card-title">Interactive Counter (LiveView)</h2>
            <p class="text-2xl font-bold text-center my-4">Count: <%= @counter %></p>
            <div class="card-actions justify-center gap-4">
              <button class="btn btn-primary" phx-click="increment">
                Increment
              </button>
              <button class="btn btn-secondary" phx-click="decrement">
                Decrement
              </button>
            </div>
          </div>
        </div>

        <!-- Form Section -->
        <div class="card bg-base-100 shadow-xl mb-8">
          <div class="card-body">
            <h2 class="card-title">DaisyUI Form Components</h2>
            <form phx-submit="submit_form">
              <div class="form-control mb-4">
                <label class="label">
                  <span class="label-text">Your Name</span>
                </label>
                <input
                  type="text"
                  name="name"
                  placeholder="Enter your name"
                  class="input input-bordered w-full"
                  required
                />
              </div>

              <div class="form-control mb-4">
                <label class="label">
                  <span class="label-text">Your Message</span>
                </label>
                <textarea
                  name="message"
                  class="textarea textarea-bordered"
                  placeholder="Enter your message"
                  required
                ></textarea>
              </div>

              <div class="form-control mt-6">
                <button type="submit" class="btn btn-primary">Submit Form</button>
              </div>
            </form>

            <%= if @form_name != "" do %>
              <div class="alert alert-success mt-4">
                <span>Thank you, <%= @form_name %>! Your message: "<%= @form_message %>"</span>
              </div>
            <% end %>
          </div>
        </div>

        <!-- Modal Section -->
        <div class="card bg-base-100 shadow-xl mb-8">
          <div class="card-body">
            <h2 class="card-title">DaisyUI Modal</h2>
            <p>Click the button below to open a modal dialog.</p>
            <div class="card-actions">
              <button class="btn btn-accent" phx-click="toggle_modal">
                Open Modal
              </button>
            </div>
          </div>
        </div>

        <%= if @show_modal do %>
          <div class="modal modal-open">
            <div class="modal-box">
              <h3 class="font-bold text-lg">Hello from LiveView Modal!</h3>
              <p class="py-4">This modal is controlled by Phoenix LiveView state. No JavaScript required!</p>
              <div class="modal-action">
                <button class="btn" phx-click="toggle_modal">Close</button>
              </div>
            </div>
          </div>
        <% end %>

        <!-- Button Showcase -->
        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <h2 class="card-title mb-4">DaisyUI Button Styles</h2>
            <div class="flex flex-wrap gap-4">
              <button class="btn">Default</button>
              <button class="btn btn-primary">Primary</button>
              <button class="btn btn-secondary">Secondary</button>
              <button class="btn btn-accent">Accent</button>
              <button class="btn btn-info">Info</button>
              <button class="btn btn-success">Success</button>
              <button class="btn btn-warning">Warning</button>
              <button class="btn btn-error">Error</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
