defmodule User.Client do
  @moduledoc """
  Interface for user functionality
  """

  @doc """
  Initialize login
  """
  @spec initLogin(binary) :: binary
  def initLogin(user) do
    GenServer.call(UserServer, {:init_login, user})
  end

  @doc """
  Execute login
  """
  @spec loginUser(binary, binary, binary) :: atom
  def loginUser(user, loginToken, sessionToken) do
    GenServer.call(UserServer, {:do_login, user, loginToken, sessionToken})
  end

  @doc """
  Register new user
  """
  @spec registerUser(binary, binary, binary) :: atom
  def registerUser(user, loginToken, storageRoot) do
    GenServer.call(UserServer, {:register, user, loginToken, storageRoot})
  end

  @doc """
  Log user out
  """
  @spec logoutUser(binary, binary) :: atom
  def logoutUser(user, sessionToken) do
    GenServer.call(UserServer, {:logout, user, sessionToken})
  end

end