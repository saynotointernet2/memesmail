defmodule Memesmail.Session.Client do
  @moduledoc """
  Implement session client
  """

  @behaviour Memesmail.Model.Session

  alias Memesmail.Model.Types, as: Types

  defp server_name, do: Memesmail.Session.Server.server_name

  @doc """
  Initialize session for user, return nonce
  """
  @spec init_session_nonce(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  def init_session_nonce(user) do
    GenServer.call(server_name(), {:init_session_nonce, user})
  end

  @doc """
  Logs User in
  """
  @spec open_session(Types.user, Types.session_token, Types.login_token) :: :valid | :invalid | {:error, String.t}
  def open_session(user, session_token, login_token) do
    GenServer.call(server_name(), {:start_session, user, session_token, login_token})
  end

  @doc """
  Verify session token for user
  """
  @spec verify_session_token(Types.user, Types.session_token) :: :valid | :invalid | {:error, String.t}
  def verify_session_token(user, token) do
    GenServer.call(server_name(), {:verify_session_token, user, token})
  end

  @doc """
  Kill session for user
  """
  @spec kill_session(Types.user) :: :ok | {:error, String.t}
  def kill_session(user) do
    GenServer.call(server_name(), {:kill_session, user})
  end

end