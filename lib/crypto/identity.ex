defmodule Memesmail.Crypto.Identity do

  alias Memesmail.Model.Types, as: T

  @moduledoc """
  Module containing identity-related crypto functions
  """

  @spec verify_user_identity(T.user_identity, T.user_identity) :: :valid_identity | :invalid_identity
  def verify_user_identity(new_identity, old_identity) do
    with %{:identity_body => old_body} <- Poison.decode!(old_identity),
         %{:identity_signing_key => old_key} <- Poison.decode!(Base.decode64(old_body)),
         %{:identity_body => new_body, :signatures => sigs} <- Poison.decode!(new_identity),
         %{:identity_signing_key => new_key} <- Poison.decode!(Base.decode64(new_body)),
         %{:identity_signature => id_sig, :custody_chain_signature => chain_sig} <- sigs,
         true <- Ed25519.valid_signature?(id_sig, new_body, new_key),
         true <- Ed25519.valid_signature?(chain_sig, new_body, old_key)
      do
      :valid_identity
    else
      _ -> :invalid_identity
    end
  end

end
