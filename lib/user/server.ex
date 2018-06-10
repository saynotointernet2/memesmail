defmodule Memesmail.User.Server do
  @moduledoc """
  Server that performs account functions
  """

  use GenServer

#  alias Memesmail.Session.Client, as: Session
#  alias Memesmail.User.C

  @name UserServer

  def server_name, do: @name

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def init(_opts) do
    {
      :ok,
      nil
    }
  end

  @doc """
  Init user login
  """
  def handle_call({:init_login, user}, _from, state) do


    nonce = :crypto.strong_rand_bytes(32)
    timestamp = :os.system_time(:millisecond)
    {
      :reply,
      nonce,
      Cache.update_nonce(state, user, nonce, timestamp)
    }
  end

end