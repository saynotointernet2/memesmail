defmodule Memesmail.Service.User do
  @moduledoc """
  Implementation of user model functionality
  """

  @behaviour Memesmail.Model.User

  alias Memesmail.Model.Types, as: Types
  alias Memesmail.Policy.User, as: Policy
  alias Memesmail.Session.Client, as: Session
  alias Memesmail.Pgstore.UserClient, as: UserStore
  alias Memesmail.Pgstore.ObjectClient, as: ObjectStore


  @doc """
  Intialize a log-in procedure
  """
  @spec init_login(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  def init_login(user) do
    with :ok <- Policy.init_login(user),
         {:ok, nonce} <- Session.init_session_nonce(user)
      do
      {:ok, nonce}
    else
      err -> err
    end
  end

  @doc """
  Perform login attempt with the provided session token
  """
  @spec login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}
  def login(user, token) do
    with :ok <- Policy.login(user, token),
         {:ok, login_token} <- UserStore.get_user_login_token(user),
         :ok <- Session.open_session(user, token, login_token),
         {:ok, root_object} <- ObjectStore.load_root_object(user)
      do
      {:ok, root_object}
    else
      :invalid -> {:error, "User provided invalid session token"}
      err -> err
    end
  end

  @doc """
  Log the user out
  """
  @spec logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  def logout(user, token) do
    with :ok <- Policy.logout(user, token),
         :ok <- Session.kill_session(user)
      do
      :ok
    else
      err -> err
    end
  end

  @doc """
  Tries to register specified user with provided token and initial root_object
  """
  @spec register_user(Types.user, Types.login_token, Types.register_token, Types.root_object) :: :ok | {:error, String.t}
  def register_user(user, login_token, register_token, root_object) do
    with :ok <- Policy.register_user(user, login_token, register_token, root_object),
         {:ok, _} <- UserStore.create_new_user(user, login_token, root_object)
      do
      :ok
    else
      err -> err
    end
  end

end