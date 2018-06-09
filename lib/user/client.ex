defmodule Memesmail.User.Client do
  @moduledoc """
  Client used to perform account functions
  """

  @behaviour Memesmail.Model.User

  alias Memesmail.Model.Types, as: Types

  defp server_name, do: Memesmail.User.Server.server_name


  @doc """
  Intialize a log-in procedure
  """
  @spec init_login(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  def init_login(user) do
    GenServer.call(server_name, {:init_login, user})
  end

  @doc """
  Perform login attempt with the provided session token
  """
  @spec do_login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}
  def do_login(user, token) do
    GenServer.call(server_name, {:do_login, user, token})
  end

  @doc """
  Log the user out
  """
  @spec logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  def logout(user, token) do
    GenServer.call(server_name, {:logout, user, token})
  end

  @doc """
  Tries to register specified user with provided token and initial root_object
  """
  @spec register_user(Types.user, Types.login_token, Types.root_object) :: :ok | {:error, String.t}
  def register_user(user, login_token, root_object) do
    GenServer.call(server_name, {:register_user, user, login_token, root_object})
  end

end