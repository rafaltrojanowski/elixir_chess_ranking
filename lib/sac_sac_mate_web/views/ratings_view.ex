defmodule SacSacMateWeb.RatingsView do
  use SacSacMateWeb, :view
  use JaSerializer.PhoenixView

  attributes [:id, :date, :name, :country, :sex]
end
