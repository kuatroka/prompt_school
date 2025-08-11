defmodule PhxLiveSvelteTemplate3Web.PageController do
  use PhxLiveSvelteTemplate3Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
