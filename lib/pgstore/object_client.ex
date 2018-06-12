defmodule Memesmail.Pgstore.ObjectClient do
  @moduledoc """
  Define the interface behavior to store data
  """

  alias Memesmail.Pgstore.Server, as: Server
  alias Memesmail.Pgstore.Queries, as: Queries

  @behaviour Memesmail.Model.Object

  @doc """
  Store data and keys for a given user
  """
  def store_object(user_id, object_body, keys) do
    Queries.store_object_query
    |> (&Postgrex.prepare!(Server.server_name, "store_object", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [ {user_id}, {object_body}, Enum.map(keys, fn key ->  {key} end)]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Add additional keys to an existing object of a user by id.
  """
  def add_keys(user_id, object_id, keys) do
    Queries.add_keys_query
    |> (&Postgrex.prepare!(Server.server_name, "add_keys", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}, Enum.map(keys, fn key -> {key} end)]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Edit body of an object by id.
  """
  def edit_body(user_id, object_id, object_body) do
    Queries.edit_body_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_body", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}, {object_body}])).()
  end

  @doc """
  Edit user's entire object by object_id
  """
  def edit_object(user_id, object_id, object_body, keys) do
    Queries.edit_object_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_object", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}, {object_body}, Enum.map(keys, fn key -> {key} end)]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Edit key for a specific object for a specific user by object, key ids.
  """
  def edit_key(user_id, object_id, key_id, key) do
    Queries.edit_object_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_key", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}, {key_id}, {key}])).()
  end

  @doc """
  Load a user's object and specific key by object_id with key_id
  """
  def load_object_with_key(user_id, object_id, key_id) do
    Queries.load_object_with_key_query
    |> (&Postgrex.prepare!(Server.server_name, "load_object_with_key", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}, {key_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Load a user's object by id with all keys
  """
  def load_object_full(user_id, object_id) do
    Queries.load_object_full_query
    |> (&Postgrex.prepare!(Server.server_name, "load_object_full", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Load all object ids for user
  """
  def load_all_ids(user_id) do
    Queries.load_all_ids_query
    |> (&Postgrex.prepare!(Server.server_name, "load_all_ids", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Load root object for user
  """
  def load_root_object(user_id) do
    Queries.load_root_object
    |> (&Postgrex.prepare!(Server.server_name, "load_root_object", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Remove object for a specific user by id
  """
  def remove_object(user_id, object_id) do
    Queries.remove_object_query
    |> (&Postgrex.prepare!(Server.server_name, "remove_object", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}])).()
  end

  @doc """
  Remove keys from a specific object for a specific user
  """
  def remove_keys(user_id, object_id, key_ids) do
    Queries.remove_keys_query
    |> (&Postgrex.prepare!(Server.server_name, "remove_keys", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}, Enum.map(key_ids, fn key_id -> {key_id} end)])).()
  end

end