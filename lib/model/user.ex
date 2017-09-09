defmodule Memesmail.Model.User do
  @moduledoc """
  Interface to account commands
  """

  alias Memesmail.Model.Types, as: Types

  @callback init_login(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  @callback do_login(Types.user, Types.session_token) :: {:ok, Types.root_object} | {:error, String.t}
  @callback logout(Types.user, Types.session_token) :: :ok | {:error, String.t}
  @callback register_user(Types.user, Types.login_token, Types.root_object) :: :ok | {:error, String.t}

end