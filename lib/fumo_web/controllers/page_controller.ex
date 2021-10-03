defmodule FumoWeb.PageController do
  use FumoWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      render(conn, "index.html")
    else
      render(conn, "landing.html")
    end
  end

end
