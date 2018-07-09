defmodule Memesmail do
  @moduledoc """
  Documentation for Memesmail.
  """

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Memesmail.Pgstore.Super, []),
      supervisor(Memesmail.Session.Super, []),
      Plug.Adapters.Cowboy.child_spec(:http, Memesmail.Web.Router, [], port: 8080)
      # Start your own worker by calling: PhoenixTry2.Worker.start_link(arg1, arg2, arg3)
      # worker(PhoenixTry2.Worker, [arg1, arg2, arg3]),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

#  # Tell Phoenix to update the endpoint configuration
#  # whenever the application is updated.
#  def config_change(changed, _new, removed) do
#    PhoenixTry2.Endpoint.config_change(changed, removed)
#    :ok
#  end


  #  use Application
  #
  #  def start(_type, _args) do
  #  end

end

