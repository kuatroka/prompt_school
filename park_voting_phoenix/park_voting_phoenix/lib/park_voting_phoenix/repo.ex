defmodule ParkVotingPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :park_voting_phoenix,
    adapter: Ecto.Adapters.SQLite3
end
