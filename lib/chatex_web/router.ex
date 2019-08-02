defmodule ChatexWeb.Router do
  use Phoenix.Router
  use Plug.ErrorHandler

  alias ChatexWeb.Endpoints.Controller, as: EndpointsController

  pipeline :api do
    plug :accepts, ["json"]
  end

  get("/", EndpointsController, :index, as: :endpoints)

  scope "/", ChatexWeb do
    pipe_through :api
  end
end
