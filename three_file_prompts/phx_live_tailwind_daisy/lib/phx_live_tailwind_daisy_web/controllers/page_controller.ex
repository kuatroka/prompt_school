defmodule PhxLiveTailwindDaisyWeb.PageController do
  use PhxLiveTailwindDaisyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
