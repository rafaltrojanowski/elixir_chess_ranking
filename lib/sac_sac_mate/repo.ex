defmodule SacSacMate.Repo do
  use Ecto.Repo,
    otp_app: :sac_sac_mate,
    adapter: Ecto.Adapters.Postgres
end
