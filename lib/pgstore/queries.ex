defmodule Memesmail.Pgstore.Queries do
  @moduledoc """
  Proc names for database
  """

  @doc """
  Storing a new data object for a specified user
  Input: {user, object_body, [keys]}
  Output: {:ok, object_id, [key_id]}
  """
  def store_object_query, do: "select mm_store_object($1, $2, $3)"

  @doc """
  Adding a list of keys for a specified data object
  Input: {user, object_id, [keys]}
  Output: {:ok, [key_id]}
  """
  def add_keys_query, do: "select mm_add_keys($1, $2, $3)"

  @doc """
  Editing object_body of an existing data object.
  Input: {user, object_id, object_body}
  Output: {:ok}
  """
  def edit_body_query, do: "select mm_edit_body($1, $2, $3)"

  @doc """
  Editing entire existing object.
  Input: {user, object_id, object_body, [keys]}
  Output: {:ok, [key_id]}
  """
  def edit_object_query, do: "select mm_edit_object($1, $2, $3, $4)"

  @doc """
  Editing a specific key for an existign object.
  Input: {user, object_id, key_id, key}
  Output: {:ok}
  """
  def edit_key_query, do: "select mm_edit_key($1, $2, $3, $4)"

  @doc """
  Retrieve object with specified id and key_id
  Input: {user, object_id, key_id}
  Output: {:ok, object_body, key}
  """
  def load_object_with_key_query, do: "select mm_load_object_with_key($1, $2, $3)"

  @doc """
  Retrieve object with all keys
  Input: {user, object_id}
  Output: {:ok, object_body, [key_id: key]}
  """
  def load_object_full_query, do: "select mm_load_object_full($1, $2)"

  @doc """
  Retrieve all object ids for a specific user.
  Input: {user}
  Output: {:ok, [object_ids]}
  """
  def load_all_ids_query, do: "select mm_load_all_ids($1)"

  @doc """
  Remove the specified object by id
  Input: {user, object_id}
  Output: {:ok}
  """
  def remove_object_query, do: "select mm_remove_object($1, $2)"

  @doc """
  Remove the specified object key by id.
  Input: {user, object_id, [key_id]}
  Output: {:ok}
  """
  def remove_keys_query, do: "select mm_remove_keys($1, $2, $3)"

  @doc """
  Retrieve the root object for a specified user.
  Input: user
  Output: {:ok, body}
  """
  def load_root_object_query, do: "select mm_load_root_object($1)"

  @doc """
  Store the root object for a specified user.
  Input: user, body
  Output: {:ok}
  """
  def store_root_object_query, do: "select mm_store_root_object($1, $2)"

  @doc """
  Get user login token
  Input: user
  Output: login_token
  """
  def get_user_login_token_query, do: "select mm_load_login_token($1)"

  @doc """
  Insert a new user with the necessary tokens into the database
  Input: {user, login_token, body}
  Output: :ok
  """
  def create_new_user_query, do: "select mm_create_new_user($1, $2, $3, $4)"

  @doc """
  Load the user's latest identity info
  Input: {user}
  Output: {user_identity}
  """
  def load_user_identity_query, do: "select mm_load_user_identity($1)"

  @doc """
  Load the user's identity history
  Input: {user}
  Output: [user_identity]
  """
  def load_user_identity_history_query, do: "select mm_load_user_identity_history($1)"

  @doc """
  Update user's identity info
  Input: {user_id, user_info}
  Output: :ok
  """
  def update_user_identity_query, do: "select mm_update_user_identity($1, $2)"

  @doc """
  Load server identity info
  Input: none
  Output: {server_identity}
  """
  def load_server_identity_query, do: "select top 1 server_info from mm_server_identity order by identity_number desc"

  @doc """
  Load server identity history
  Input: none
  Output: {[server_identity]}
  """
  def load_server_identity_history_query, do: "select server_info from mm_server_identity order by identity_number desc"

end
