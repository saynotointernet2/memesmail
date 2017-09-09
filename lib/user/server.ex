defmodule Memesmail.User.Server do
  @moduledoc """
  Server that performs account functions
  """

  use GenServer

  alias Memesmail.Session.Client, as Session
  alias Memesmail.User.C

  @name UserServer

  def server_name, do: @name

  def start_link do
    GenServer.start_link(__MODULE__, [name: @name])
  end

  def init(_opts) do
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

  @callback init_login(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  @callback do_login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}
  @callback logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  @callback register_user(Types.user, Types.login_token, Types.root_object) :: :ok | {:error, String.t}

end