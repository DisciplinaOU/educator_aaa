defmodule Educator.AAA.Router do
  use Educator.AAA, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", Educator.AAA do
    pipe_through :api

    get "/healthcheck", StatusController, :healthcheck

    post "/accounts", AccountController, :register

    post "/sessions", SessionController, :create
  end
end
