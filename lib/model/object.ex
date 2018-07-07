defmodule Memesmail.Model.Object do
  @moduledoc """
  Interface for data access
  """

  alias Memesmail.Model.Types, as: T

  @callback store_object(T.user, T.session_token, T.body, [T.key]) :: {:ok, T.stored_ids} | {:error, String.t}
  @callback add_keys(T.user, T.session_token, T.object_id, [T.key]) :: {:ok, [T.key_id]} | {:error, String.t}
  @callback edit_body(T.user, T.session_token, T.object_id, T.body) :: :ok | {:error, String.t}
  @callback edit_object(T.user, T.session_token, T.object_id, T.body, [T.key]) :: {:ok, [T.key_id]} | {:error, String.t}
  @callback edit_key(T.user, T.session_token, T.object_id, T.key_id, T.key) :: :ok | {:error, String.t}
  @callback load_object_with_key(T.user, T.session_token, T.object_id, T.key_id) :: {:ok, T.object_key} | {:error, String.t}
  @callback load_object_full(T.user, T.session_token, T.object_id) :: {:ok, Type.object_full} | {:error, String.t}
  @callback load_all_ids(T.user, T.session_token) :: {:ok, [T.object_id]} | {:error, String.t}
  @callback remove_object(T.user, T.session_token, T.object_id) :: :ok | {:error, String.t}
  @callback remove_keys(T.user, T.session_token, T.object_id, [T.key_id]) :: :ok | {:error, String.t}
  @callback load_root_object(T.user, T.session_token) :: {:ok, T.body} | {:error, String.t}
  @callback store_root_object(T.user, T.session_token, T.body) :: :ok | {:error, String.t}

end