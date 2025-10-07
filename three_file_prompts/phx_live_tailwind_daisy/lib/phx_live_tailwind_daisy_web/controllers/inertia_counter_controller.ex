defmodule PhxLiveTailwindDaisyWeb.InertiaCounterController do
  use PhxLiveTailwindDaisyWeb, :controller
  import Inertia.Controller

  alias PhxLiveTailwindDaisy.{Repo, Counter}

  plug :put_layout, html: {PhxLiveTailwindDaisyWeb.InertiaHTML, :root}

  def index(conn, _params) do
    # Get or create the counter from database (same logic as LiveView)
    counter = case Repo.get(Counter, 1) do
      nil ->
        %Counter{id: 1, value: 0}
        |> Repo.insert!()
      existing_counter ->
        existing_counter
    end

    conn
    |> render_inertia("Counter", %{counter: counter.value})
  end

  def increment(conn, _params) do
    counter = Repo.get!(Counter, 1)
    new_value = counter.value + 1

    counter
    |> Counter.changeset(%{value: new_value})
    |> Repo.update!()

    json(conn, %{value: new_value})
  end

  def decrement(conn, _params) do
    counter = Repo.get!(Counter, 1)
    new_value = counter.value - 1

    counter
    |> Counter.changeset(%{value: new_value})
    |> Repo.update!()

    json(conn, %{value: new_value})
  end
end
