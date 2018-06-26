defmodule Memesmail.Service.Object do
  @moduledoc """
  Object-Access implementation
  """

  @behaviour Memesmail.Model.Object

  alias Memesmail.Model.Types, as: T
  alias Memesmail.Policy.Object, as: Policy
  alias Memesmail.Session.Client, as: Session
  alias Memesmail.Pgstore.UserClient, as: UserStore
  alias Memesmail.Pgstore.ObjectClient, as: ObjectStore

  @spec store_object(T.user, T.session_token, binary, list) :: {:ok, T.stored_ids} | {:error, String.t}
  def store_object(user, token, body, keys) do
    with :ok <- Policy.store_object(user, token, {body}, )
  end

  @spec add_keys(T.user, T.session_token, binary, list) :: {:ok, [T.key_id]} | {:error, String.t}

  @spec edit_body(T.user, T.session_token, binary, binary) :: :ok | {:error, String.t}

  @spec edit_object(T.user, T.session_token, binary, binary, list) :: {:ok, [T.key_id]} | {:error, String.t}

  @spec edit_key(T.user, T.session_token, binary, binary, binary) :: :ok | {:error, String.t}

  @spec load_object_with_key(T.user, T.session_token, binary, binary) :: {:ok, T.object_key} | {:error, String.t}

  @spec load_object_full(T.user, T.session_token, binary) :: {:ok, Type.object_full} | {:error, String.t}

  @spec load_all_ids(T.user, T.session_token) :: {:ok, [T.object_id]} | {:error, String.t}

  @spec load_root_object(T.user, T.session_token) :: {:ok, T.body} | {:error, String.t}

  @spec remove_object(T.user, T.session_token, binary) :: :ok | {:error, String.t}

  @spec remove_keys(T.user, T.session_token, binary, list) :: :ok | {:error, String.t}

end
