defmodule KeyfinderWeb.Router do
  use KeyfinderWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", KeyfinderWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/lookup", PageController, :lookup)
    get("/lookup/:key", KvController, :lookup)
  end

  scope "/insert", KeyfinderWeb do
    pipe_through(:api)

    post("/", KvController, :insert)
  end
end
