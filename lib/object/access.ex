defmodule Object.Access do
  @moduledoc """
  Objects access interface
  """

  alias Object.Types, as: Types

  @callback store_object(binary, binary, list) :: {:ok, Types.stored_ids} | {:error, String.t}
  @callback add_keys(binary, binary, list) :: {:ok, [Types.key_id]} | {:error, String.t}
  @callback edit_body(binary, binary, binary) :: {:ok} | {:error, String.t}
  @callback edit_object(binary, binary, binary, list) :: {:ok, [Types.key_id]} | {:error, String.t}
  @callback edit_key(binary, binary, binary, binary) :: {:ok} | {:error, String.t}
  @callback load_object_with_key(binary, binary, binary) :: {:ok, Types.object_key} | {:error, String.t}
  @callback load_object_full(binary, binary) :: {:ok, Types.object_full} | {:error, String.t}
  @callback load_all_ids(binary) :: {:ok, [Types.object_id]} | {:error, String.t}
  @callback remove_object(binary, binary) :: {:ok} | {:error, String.t}
  @callback remove_keys(binary, binary, list) :: {:ok} | {:error, String.t}
end