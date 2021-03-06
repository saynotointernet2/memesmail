defmodule Memesmail.Session.Server do
  @moduledoc """
  Server to handle user session.
  """

  use GenServer

  alias Memesmail.Session.SessionCache, as: Cache
  alias Memesmail.Model.Types, as: Types
  alias Memesmail.Crypto.Session, as: Crypto

  @name SessionServer

  def server_name, do: @name

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def init(opts) do
    {
      :ok,
      Cache.new(opts[:nonce_timeout], opts[:login_timeout])
    }
  end


  @doc """
  Init user auth
  """
  def handle_call({:init_session_nonce, user, cnonce}, _from, state) do
    snonce = :crypto.strong_rand_bytes(32)
    timestamp = :os.system_time(:millisecond)
    {
      :reply,
      {:ok, snonce},
      Cache.update_nonce(state, user, {cnonce, snonce}, timestamp)
    }
  end

  @doc """
  Log user in
  """
  def handle_call({:start_session, user, session_token, login_token}, _from, state) do
    timestamp = :os.system_time(:millisecond)
    case Cache.try_nonce(state, user, timestamp) do
      {:ok, {cnonce, snonce}} ->
        computed = compute_token(user, login_token, cnonce, snonce)
        if (computed == session_token) do
          {:reply, :valid, Cache.set_token(state, user, session_token, timestamp)}
        else
          {:reply, :invalid, Cache.clear_user(state, user)}
        end
      {:timeout, cache} -> {:reply, :invalid, cache}
      _ -> {:reply, :invalid, state}
    end
  end

  @doc """
  Verify user sessionToken
  """
  def handle_call({:verify_session_token, user, token}, _from, state) do
    timestamp = :os.system_time(:millisecond)
    case Cache.try_token(state, user, token, timestamp) do
      {:ok, cache} -> {:reply, :valid, cache}
      {_, cache} -> {:reply, :invalid, cache}
    end
  end

  @doc """
  Kill user session
  """
  def handle_call({:kill_session, user}, _from, state) do
    {
      :reply,
      :ok,
      Cache.clear_user(state, user)
    }
  end

  #TODO Currently we will not use the loginToken parameter
  @spec compute_token(Types.user, Types.login_token, Types.nonce, Types.nonce) :: binary
  def compute_token(user, token, cnonce, snonce) do
    Crypto.compute_session_token(user, token, cnonce, snonce)
  end

end
