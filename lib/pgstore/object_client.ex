defmodule Memesmail.Pgstore.ObjectClient do
  @moduledoc """
  Define the interface behavior to store data
  """

  alias Memesmail.Model.Types, as: T
  alias Memesmail.Pgstore.Server, as: Server
  alias Memesmail.Pgstore.Queries, as: Queries

  @doc """
  Store data and keys for a given user
  """
  @spec store_object(T.user, T.body, [T.key]) :: {:ok, T.stored_ids} | {:error, String.t}
  def store_object(user_id, object_body, keys) do
    Queries.store_object_query
    |> (&Postgrex.prepare!(Server.server_name, "store_object", &1)).()
    |> (
         &Postgrex.execute!(
           Server.server_name,
           &1,
           [{user_id}, {object_body}, Enum.map(keys, fn (key) -> {key} end)]
         ).rows).()
    |> hd
    |> hd
    |> (
         fn ({obj_id, key_ids}) -> {:ok, {elem(obj_id, 0), Enum.map(key_ids, fn (key_id) -> elem(key_id, 0) end)}}
         end).()
  end

  @doc """
  Add additional keys to an existing object of a user by id.
  """
  @spec add_keys(T.user, T.object_id, [T.key]) :: {:ok, [T.key_id]} | {:error, String.t}
  def add_keys(user_id, object_id, keys) do
    Queries.add_keys_query
    |> (&Postgrex.prepare!(Server.server_name, "add_keys", &1)).()
    |> (
         &Postgrex.execute!(
           Server.server_name,
           &1,
           [{user_id}, {object_id}, Enum.map(keys, fn (key) -> {key} end)]
         ).rows).()
    |> hd
    |> hd
    |> (&{:ok, Enum.map(&1, fn (key) -> elem(key, 0) end)}).()
  end

  @doc """
  Edit body of an object by id.
  """
  @spec edit_body(T.user, T.object_id, T.body) :: :ok | {:error, String.t}
  def edit_body(user_id, object_id, object_body) do
    Queries.edit_body_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_body", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}, {object_body}])).()
    :ok
  end

  @doc """
  Edit user's entire object by object_id
  """
  @spec edit_object(T.user, T.object_id, T.body, [T.key]) :: {:ok, [T.key_id]} | {:error, String.t}
  def edit_object(user_id, object_id, object_body, keys) do
    Queries.edit_object_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_object", &1)).()
    |> (
         &Postgrex.execute!(
           Server.server_name,
           &1,
           [{user_id}, {object_id}, {object_body}, Enum.map(keys, fn (key) -> {key} end)]
         ).rows).()
    |> hd
    |> hd
    |> (&{:ok, Enum.map(&1, fn (key) -> elem(key, 0) end)}).()
  end

  @doc """
  Edit key for a specific object for a specific user by object, key ids.
  """
  @spec edit_key(T.user, T.object_id, T.key_id, T.key) :: :ok | {:error, String.t}
  def edit_key(user_id, object_id, key_id, key) do
    Queries.edit_object_query
    |> (&Postgrex.prepare!(Server.server_name, "edit_key", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}, {key_id}, {key}])).()
    :ok
  end

  @doc """
  Load a user's object and specific key by object_id with key_id
  """
  @spec load_object_with_key(T.user, T.object_id, T.key_id) :: {:ok, T.object_key} | {:error, String.t}
  def load_object_with_key(user_id, object_id, key_id) do
    Queries.load_object_with_key_query
    |> (&Postgrex.prepare!(Server.server_name, "load_object_with_key", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}, {key_id}]).rows).()
    |> hd
    |> hd
    |> (fn ({obj, key}) -> {:ok, {elem(obj, 0), elem(key, 0)}} end).()
  end

  @doc """
  Load a user's object by id with all keys
  """
  @spec load_object_full(T.user, T.object_id) :: {:ok, T.object_full} | {:error, String.t}
  def load_object_full(user_id, object_id) do
    Queries.load_object_full_query
    |> (&Postgrex.prepare!(Server.server_name, "load_object_full", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}, {object_id}]).rows).()
    |> hd
    |> hd
    |> (fn ({body, keypairs}) ->
      {
        :ok,
        {
          elem(body, 0),
          Enum.map(
            keypairs,
            fn ({key_id, key}) ->
              {elem(key_id, 0), elem(key, 0)}
            end
          )
        }
      }
        end).()

  end

  @doc """
  Load all object ids for user
  """
  @spec load_all_ids(T.user) :: {:ok, [T.object_id]} | {:error, String.t}
  def load_all_ids(user_id) do
    Queries.load_all_ids_query
    |> (&Postgrex.prepare!(Server.server_name, "load_all_ids", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, Enum.map(&1, fn (id) -> elem(id, 0) end)}).()
  end

  @doc """
  Remove object for a specific user by id
  """
  @spec remove_object(T.user, T.object_id) :: :ok | {:error, String.t}
  def remove_object(user_id, object_id) do
    Queries.remove_object_query
    |> (&Postgrex.prepare!(Server.server_name, "remove_object", &1)).()
    |> (&Postgrex.execute(Server.server_name, &1, [{user_id}, {object_id}])).()
    :ok
  end

  @doc """
  Remove keys from a specific object for a specific user
  """
  @spec remove_keys(T.user, T.object_id, [T.key_id]) :: :ok | {:error, String.t}
  def remove_keys(user_id, object_id, key_ids) do
    Queries.remove_keys_query
    |> (&Postgrex.prepare!(Server.server_name, "remove_keys", &1)).()
    |> (
         &Postgrex.execute(
           Server.server_name,
           &1,
           [{user_id}, {object_id}, Enum.map(key_ids, fn (key_id) -> {key_id} end)]
         )).()
    :ok
  end

  @doc """
  Load root object for user
  """
  @spec load_root_object(T.user) :: {:ok, T.body} | {:error, String.t}
  def load_root_object(user_id) do
    Queries.load_root_object_query
    |> (&Postgrex.prepare!(Server.server_name, "load_root_object", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user_id}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, elem(&1, 0)}).()
  end

  @doc """
  Store root object for user
  """
  @spec store_root_object(T.user, T.body) :: :ok | {:error, String.t}
  def store_root_object(user, root_object) do
    Queries.store_root_object_query
    |> (&Postgrex.prepare!(Server.server_name, "store_root_object", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user}, {root_object}]).rows).()
    :ok
  end

end