defmodule ChatexWeb.Endpoints.Controller do
  use ChatexWeb.Controller

  alias ChatexWeb.Endpoints.View

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> put_view(View)
    |> render("endpoints.json")
  end
end
