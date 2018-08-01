defmodule Memesmail.Crypto.Identity do

  alias Memesmail.Model.Types, as: T

  @moduledoc """
  Module containing identity-related crypto functions
  """

  @spec verify_user_identity(T.user_identity, T.user_identity) :: :valid_identity | :invalid_identity
  def verify_user_identity(_new_identity, _old_identity) do
    :valid_identity
  end

end
