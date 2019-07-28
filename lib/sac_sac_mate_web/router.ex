defmodule SacSacMateWeb.Router do
  use SacSacMateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SacSacMateWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/players", PlayerController
    resources "/ratings", RatingController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SacSacMateWeb do
  #   pipe_through :api
  # end
end
