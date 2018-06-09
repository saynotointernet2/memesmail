defmodule Memesmail.Model.Session do
  @moduledoc """
  Interface for current user sessions
  """

  alias Memesmail.Model.Types, as: Types

  @callback init_session_nonce(Types.user) :: {:ok, Types.nonce} | {:error, String.t}
  @callback open_session(Types.user, Types.session_token, Types.login_token) :: :ok | :invalid | {:error, String.t}
  @callback verify_session_token(Types.user, Types.session_token) :: :ok | :invalid | {:error, String.t}
  @callback kill_session(Types.user) :: :ok | {:error, String.t}

end