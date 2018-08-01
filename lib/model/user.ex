defmodule Memesmail.Model.User do
  @moduledoc """
  Interface to account commands
  """

  alias Memesmail.Model.Types, as: Types

  @callback init_login(Types.user, Types.nonce) :: {:ok, Types.nonce} | {:error, String.t}

  @callback login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}

  @callback logout(Types.user, Types.session_token) :: :ok | {:error, String.t}

  @callback register_user(Types.user, Types.login_token, Types.register_token, Types.root_object, T.user_identity) :: :ok | {:error, String.t}

  @callback update_identity(Types.user, Types.session_token, Types.user_identity) :: :ok | {:error, String.t}

end