defmodule Educator.AAA.Router do
  use Educator.AAA, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Educator.AAA do
    pipe_through :api

    get "/healthcheck", StatusController, :healthcheck
  end
end
