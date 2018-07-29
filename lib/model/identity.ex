defmodule Memesmail.Model.Identity do
  @moduledoc """
  Behaviour for object service
  """

  alias Memesmail.Model.Types, as: T

  @callback user_identity(T.user) :: {:ok, T.user_identity} | {:error, String.t}
  @callback user_identity_history(T.user) :: {:ok, [T.user_identity]} | {:error, String.t}
  @callback server_identity() :: {:ok, T.server_identity} | {:error, String.t}
  @callback server_identity_history() :: {:ok, [T.server_identity]} | {:error, String.t}

end
