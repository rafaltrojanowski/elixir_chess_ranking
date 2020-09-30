defmodule SacSacMateWeb.RatingView do
  use SacSacMateWeb, :view
  use JaSerializer.PhoenixView

  import Torch.TableView
  import Torch.FilterView

  attributes [:id, :date, :name, :country, :sex]
end
