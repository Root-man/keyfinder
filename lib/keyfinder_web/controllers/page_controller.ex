defmodule KeyfinderWeb.PageController do
  use KeyfinderWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def lookup(conn, _params) do
    render(conn, "lookup.html")
  end
end
