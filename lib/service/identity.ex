defmodule Memesmail.Service.Identity do
  @moduledoc """
  Identity service
  """

  @behaviour Memesmail.Model.Identity

  alias Memesmail.Model.Types, as: T
  alias Memesmail.Policy.Identity, as: Policy
  alias Memesmail.Pgstore.IdentityClient, as: IdStore

  @spec user_identity(T.user) :: {:ok, T.user_identity} | {:error, String.t}
  def user_identity(user) do
    with :ok <- Policy.user_identity(user)
      do
      IdStore.user_identity(user)
    else
      err -> err
    end
  end

  @spec user_identity_history(T.user) :: {:ok, [T.user_identity]} | {:error, String.t}
  def user_identity_history(user) do
    with :ok <- Policy.user_identity_history(user)
      do
      IdStore.user_identity_history(user)
    else
      err -> err
    end
  end

  @spec server_identity() :: {:ok, T.server_identity} | {:error, String.t}
  def server_identity() do
    with :ok <- Policy.server_identity()
      do
      IdStore.server_identity()
    else
      err -> err
    end
  end

  @spec server_identity_history() :: {:ok, [T.server_identity]} | {:error, String.t}
  def server_identity_history() do
    with :ok <- Policy.server_identity_history()
      do
      IdStore.server_identity_history()
    else
      err -> err
    end
  end

end
