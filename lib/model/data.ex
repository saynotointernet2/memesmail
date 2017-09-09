defmodule Memesmail.Model.Data do
  @moduledoc """
  Interface for data access
  """

  alias Memesmail.Model.Types, as: Types

  @callback store_object(Types.user, binary, list) :: {:ok, Types.stored_ids} | {:error, String.t}
  @callback add_keys(Types.user, binary, list) :: {:ok, [Types.key_id]} | {:error, String.t}
  @callback edit_body(Types.user, binary, binary) :: :ok | {:error, String.t}
  @callback edit_object(Types.user, binary, binary, list) :: {:ok, [Types.key_id]} | {:error, String.t}
  @callback edit_key(Types.user, binary, binary, binary) :: :ok | {:error, String.t}
  @callback load_object_with_key(Types.user, binary, binary) :: {:ok, Types.object_key} | {:error, String.t}
  @callback load_object_full(Types.user, binary) :: {:ok, Type.object_full} | {:error, String.t}
  @callback load_all_ids(Types.user) :: {:ok, [Types.object_id]} | {:error, String.t}
  @callback load_root_object(Types.user) :: {:ok, Types.body} | {:error, String.t}
  @callback remove_object(Types.user, binary) :: :ok | {:error, String.t}
  @callback remove_keys(Types.user, binary, list) :: :ok | {:error, String.t}

end