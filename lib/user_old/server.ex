defmodule User.Server do
  @moduledoc """
  Server that handles user-specific commands
  """

  @name UserServer
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init do
    {}
  end

  @doc """
  Execute registration
  """
  def handle_call({:register, user, loginToken, storageRoot}, _from, state) do
    case Data.UserClient.createNewUser(DataServer, {user, loginToken, storageRoot}) do
      {:ok, _} ->
        {
          :reply,
          :ok,
          state
        }
      _ ->
        {
          :reply,
          :error,
          state
        }
    end
  end

  @doc """
  Initialize login
  """
  def handle_call({:init_login, user}, _from, state) do
    {
      :reply,
      Auth.Client.initSession(AuthServer, user),
      state
    }
  end

  @doc """
  Execute login
  """
  def handle_call({:do_login, user, sessionToken}, _from , state) do
    case Data.UserClient.getUserLoginToken(DataServer, user) do
      {:ok, loginToken} ->
        {
          :reply,
          Auth.Client.loginUser(AuthServer, user, loginToken, sessionToken),
          state
        }
      {:error, _} ->
        {
          :reply,
          :invalid,
          state
        }
    end
  end

  def handle_call({:logout, user, sessionToken}, _from, state) do
    case Auth.Client.verifySession(AuthServer, user, sessionToken) do
      :valid ->
      {
        :reply,
        Auth.Client.killSession(AuthServer, user),
        state
      }
      _ ->
      {
        :reply,
        :error,
        state
      }
    end
  end
end

#  defmodule UserStates do
#    @moduledoc """
#    A datatype for managing state of user commands.
#    """
#
#    defstruct useradd: %{}, passwd: %{}, useradd_timeout: 60000, passwd_timeout: 60000
#  end

#  @doc """
#  Initialize registration
#  """
#  def handle_call({:init_register, user}, _from, state) do
#    nonce = :crypto.strong_rand_bytes(32)
#    {
#      :reply,
#      nonce,
#      %UserStates{
#        state |
#        useradd: Map.put(
#          state.useradd,
#          user,
#          {
#            nonce,
#            :os.system_time(:millisecond)
#          })
#      }
#    }
#  end
#
#  @doc """
#  Initialize password change
#  """
#  def handle_call({:init_passwd, user}, _from, state) do
#    nonce = :crypto.strong_rand_bytes(32)
#    {
#      :reply,
#      nonce,
#      %UserStates{
#        state |
#        passwd: Map.put(
#          state.passwd,
#          user,
#          {
#            nonce,
#            :os.system_time(:millisecond)
#          })
#      }
#    }
#  end

#  @doc """
#  Execute password change
#  """
#  def handle_call({:do_passwd}, _from, state) do
#  end

