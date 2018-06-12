defmodule Memesmail.User.Server do
  @moduledoc """
  Server that handles user-specific commands
  """

  use GenServer

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

#  @doc """
#  Execute registration
#  """
#  def handle_call({:register, user, login_token, storage_root}, _from, state) do
#    case Data.UserClient.createNewUser(DataServer, {user, login_token, storage_root}) do
#      {:ok, _} ->
#        {
#          :reply,
#          :ok,
#          state
#        }
#      _ ->
#        {
#          :reply,
#          :error,
#          state
#        }
#    end
#  end
#
#  @doc """
#  Initialize login
#  """
#  def handle_call({:init_login, user}, _from, state) do
#    {
#      :reply,
#      Auth.Client.initSession(AuthServer, user),
#      state
#    }
#  end
#
#  @doc """
#  Execute login
#  """
#  def handle_call({:do_login, user, sessionToken}, _from , state) do
#    case Data.UserClient.getUserLoginToken(DataServer, user) do
#      {:ok, loginToken} ->
#        {
#          :reply,
#          Auth.Client.loginUser(AuthServer, user, loginToken, sessionToken),
#          state
#        }
#      {:error, _} ->
#        {
#          :reply,
#          :invalid,
#          state
#        }
#    end
#  end
#
#  def handle_call({:logout, user, sessionToken}, _from, state) do
#    case Auth.Client.verifySession(AuthServer, user, sessionToken) do
#      :valid ->
#        {
#          :reply,
#          Auth.Client.killSession(AuthServer, user),
#          state
#        }
#      _ ->
#        {
#          :reply,
#          :error,
#          state
#        }
#    end
#  end
end
