defmodule Keyfinder.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Keyfinder.Repo, []),
      supervisor(KeyfinderWeb.Endpoint, []),
      {Keyfinder.Keystore, Application.get_env(:keyfinder, :load_from_db)}
    ]

    opts = [strategy: :one_for_one, name: Keyfinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    KeyfinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
