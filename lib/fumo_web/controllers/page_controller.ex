defmodule FumoWeb.PageController do
  use FumoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
