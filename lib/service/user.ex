defmodule Memesmail.Service.User do
  @moduledoc """
  Implementation of user model functionality
  """

  @behaviour Memesmail.Model.User

  alias Memesmail.Model.Types, as: T
  alias Memesmail.Policy.User, as: Policy
  alias Memesmail.Session.Client, as: Session
  alias Memesmail.Pgstore.UserClient, as: UserStore
  alias Memesmail.Pgstore.ObjectClient, as: ObjectStore
  alias Memesmail.Pgstore.IdentityClient, as: IdStore
  alias Memesmail.Crypto.Identity, as: IdCrypto


  @doc """
  Intialize a log-in procedure
  """
  @spec init_login(T.user, T.nonce) :: {:ok, T.nonce} | {:error, String.t}
  def init_login(user, cnonce) do
    with :ok <- Policy.init_login(user, cnonce),
         {:ok, nonce} <- Session.init_session_nonce(user, cnonce)
      do
      {:ok, nonce}
    else
      err -> err
    end
  end

  @doc """
  Perform login attempt with the provided session token
  """
  @spec login(T.user, T.session_token) :: {:ok, T.body} | {:error, String.t}
  def login(user, token) do
    with :ok <- Policy.login(user, token),
         {:ok, login_token} <- UserStore.get_user_login_token(user),
         :valid <- Session.open_session(user, token, login_token),
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
  @spec logout(T.user, T.session_token) :: :ok | {:error, String.t}
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
  Try to register specified user with provided token and initial root_object
  """
  @spec register_user(T.user, T.login_token, T.register_token, T.body, T.user_identity) :: :ok | {:error, String.t}
  def register_user(user, login_token, register_token, root_object, identity) do
    with :ok <- Policy.register_user(user, login_token, register_token, root_object, identity),
         :ok <- UserStore.create_new_user(user, login_token, root_object, identity)
      do
      :ok
    else
      :error -> {:error, "Failed to register user"}
      err -> err
    end
  end

  @doc """
  Try to update identity for specified user
  """
  @spec update_identity(T.user, T.session_token, T.user_identity) :: :ok | {:error, String.t}
  def update_identity(user, token, new_identity) do
    with :ok <- Policy.update_identity(user, token, new_identity),
         :valid <- Session.verify_session_token(user, token),
         {:ok, old_identity} <- IdStore.user_identity(user),
         :valid_identity <- IdCrypto.verify_user_identity(new_identity, old_identity),
         :ok <- UserStore.update_identity(user, new_identity)
      do
      :ok
    else
      :invalid -> {:error, "Failed to validate session token"}
      :invalid_identity -> {:error, "Failed to validate new identity object"}
      err -> err
    end
  end
end