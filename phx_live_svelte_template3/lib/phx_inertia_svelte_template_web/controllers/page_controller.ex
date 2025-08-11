defmodule PhxInertiaSvelteTemplateWeb.PageController do
  use PhxInertiaSvelteTemplateWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
