defmodule PhxLiveTailwindDaisy.Repo do
  use Ecto.Repo,
    otp_app: :phx_live_tailwind_daisy,
    adapter: Ecto.Adapters.Postgres
end
