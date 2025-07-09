defmodule ParkVotingPhoenixWeb.PageController do
  use ParkVotingPhoenixWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
