defmodule Memesmail.Policy.Identity do
  @moduledoc """
  Policy for identity service
  """

  alias Memesmail.Model.Types, as: T

  @spec user_identity(T.user) :: :ok | {:error, String.t}
  def user_identity(_user) do
    :ok
  end

  @spec user_identity_history(T.user) :: :ok | {:error, String.t}
  def user_identity_history(_user) do
    :ok
  end

  @spec server_identity() :: :ok | {:error, String.t}
  def server_identity() do
    :ok
  end

  @spec server_identity_history() :: :ok | {:error, String.t}
  def server_identity_history() do
    :ok
  end

end
