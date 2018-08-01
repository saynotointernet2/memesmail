defmodule Memesmail.Crypto.Session do

  alias Memesmail.Model.Types, as: T

  @moduledoc """
  Cryptographic functions for session-token generation
  """

  @spec compute_session_token(T.user, T.login_token, T.nonce, T.nonce) :: T.session_token
  def compute_session_token(user, login_token, cnonce, snonce) do
    :crypto.hash(:sha512, cnonce <> user <> login_token <> snonce)
  end

end
