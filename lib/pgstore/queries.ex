defmodule Memesmail.Pgstore.Queries do
  @moduledoc """
  Proc names for database
  """

  @doc """
  Storing a new data object for a specified user
  Input: {user_id, object_body, [keys]}
  Output: {:ok, object_id, [key_id]}
  """
  def store_object_query, do: "select mm_store_object($1, $2, $3)"

  @doc """
  Adding a list of keys for a specified data object
  Input: {user_id, object_id, [keys]}
  Output: {:ok, [key_id]}
  """
  def add_keys_query, do: "select mm_add_keys($1, $2, $3)"

  @doc """
  Editing object_body of an existing data object.
  Input: {user_id, object_id, object_body}
  Output: {:ok}
  """
  def edit_body_query, do: "select mm_edit_body($1, $2, $3)"

  @doc """
  Editing entire existing object.
  Input: {user_id, object_id, object_body, [keys]}
  Output: {:ok, [key_id]}
  """
  def edit_object_query, do: "select mm_edit_object($1, $2, $3, $4)"

  @doc """
  Editing a specific key for an existign object.
  Input: {user_id, object_id, key_id, key}
  Output: {:ok}
  """
  def edit_key_query, do: "select mm_edit_key($1, $2, $3, $4)"

  @doc """
  Retrieve object with specified id and key_id
  Input: {user_id, object_id, key_id}
  Output: {:ok, object_body, key}
  """
  def load_object_with_key_query, do: "select mm_load_object_with_key($1, $2, $3)"

  @doc """
  Retrieve object with all keys
  Input: {user_id, object_id}
  Output: {:ok, object_body, [key_id: key]}
  """
  def load_object_full_query, do: "select mm_load_object_full($1, $2)"

  @doc """
  Retrieve all object ids for a specific user.
  Input: {user_id}
  Output: {:ok, [object_ids]}
  """
  def load_all_ids_query, do: "select mm_load_all_ids($1)"

  @doc """
  Retrieve the root object for a specified user.
  Input: {user_id}
  Output: {:ok, body}
  """
  def load_root_object, do: "select mm_load_root_object($1)"

  @doc """
  Remove the specified object by id
  Input: {user_id, object_id}
  Output: {:ok}
  """
  def remove_object_query, do: "select mm_remove_object($1, $2)"

  @doc """
  Remove the specified object key by id.
  Input: {user_id, object_id, [key_id]}
  Output: {:ok}
  """
  def remove_keys_query, do: "select mm_remove_keys($1, $2, $3)"

  @doc """
  Get user login token
  Input: {user_id}
  Output: {login_token}
  """
  def get_user_login_token, do: "select login_token from mm_user where user_id = $1;"

  @doc """
  Insert a new user with the necessary tokens into the database
  Input: {user_id, login_token, object_body}
  """
  def create_new_user, do: "insert into mm_user (user_id, login_token, storage_root) VALUES ($1, $2, $3);"

end
