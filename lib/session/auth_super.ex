defmodule Memesmail.Session.Super do
  @moduledoc false
  
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Memesmail.Session.Server, [[nonce_timeout: 60000, login_timeout: 12000]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end