defmodule Memesmail.Policy.Object do
  @moduledoc """
  Policy for object commands
  """

  alias Memesmail.Model.Types, as: T

  @spec store_object(T.user, T.session_token, T.body, [T.key]) :: :ok | {:error, String.t}
  def store_object(user, token, body, keys) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- body_valid(body),
         :ok <- keys_valid(keys)
      do
      :ok
    else
      error -> error
    end
  end

  @spec add_keys(T.user, T.session_token, T.object_id, [T.key]) :: :ok | {:error, String.t}
  def add_keys(user, token, object_id, keys) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- keys_valid(keys)
      do
      :ok
    else
      error -> error
    end
  end

  @spec edit_body(T.user, T.session_token, T.object_id, T.body) :: :ok | {:error, String.t}
  def edit_body(user, token, object_id, body) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- body_valid(body)
      do
      :ok
    else
      error -> error
    end
  end

  @spec edit_object(T.user, T.session_token, T.object_id, T.body, [T.key]) :: :ok | {:error, String.t}
  def edit_object(user, token, object_id, body, keys) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- body_valid(body),
         :ok <- keys_valid(keys)
      do
      :ok
    else
      error -> error
    end
  end

  @spec edit_key(T.user, T.session_token, T.object_id, T.key_id, T.key) :: :ok | {:error, String.t}
  def edit_key(user, token, object_id, key_id, key) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- key_id_valid(key_id),
         :ok <- key_valid(key)
      do
      :ok
    else
      error -> error
    end
  end

  @spec load_object_with_key(T.user, T.session_token, T.object_id, T.key_id) :: :ok | {:error, String.t}
  def load_object_with_key(user, token, object_id, key_id) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- key_id_valid(key_id)
      do
      :ok
    else
      error -> error
    end
  end

  @spec load_object_full(T.user, T.session_token, T.object_id) :: :ok | {:error, String.t}
  def load_object_full(user, token, object_id) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id)
      do
      :ok
    else
      error -> error
    end
  end

  @spec load_all_ids(T.user, T.session_token) :: :ok | {:error, String.t}
  def load_all_ids(user, token) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token)
      do
      :ok
    else
      error -> error
    end
  end

  @spec remove_object(T.user, T.session_token, T.object_id) :: :ok | {:error, String.t}
  def remove_object(user, token, object_id) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id)
      do
      :ok
    else
      error -> error
    end
  end

  @spec remove_keys(T.user, T.session_token, T.object_id, [T.key_id]) :: :ok | {:error, String.t}
  def remove_keys(user, token, object_id, key_ids) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- object_id_valid(object_id),
         :ok <- key_ids_valid(key_ids)
      do
      :ok
    else
      error -> error
    end
  end

  @spec load_root_object(T.user, T.session_token) :: :ok | {:error, String.t}
  def load_root_object(user, token) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token)
      do
      :ok
    else
      error -> error
    end
  end

  @spec store_root_object(T.user, T.session_token, T.body) :: :ok | {:error, String.t}
  def store_root_object(user, token, root_object) do
    with :ok <- user_valid(user),
         :ok <- session_token_valid(token),
         :ok <- body_valid(root_object)
      do
      :ok
    else
      error -> error
    end
  end

  @spec user_valid(T.user) :: :ok | {:error, String.t}
  defp user_valid(_user) do
    :ok
  end

  @spec session_token_valid(T.session_token) :: :ok | {:error, String.t}
  defp session_token_valid(_token) do
    :ok
  end

  @spec body_valid(T.body) :: :ok | {:error, String.t}
  defp body_valid(_body) do
    :ok
  end

  @spec key_valid(T.key) :: :ok | {:error, String.t}
  defp key_valid(_key) do
    :ok
  end

  @spec object_id_valid(T.object_id) :: :ok | {:error, String.t}
  defp object_id_valid(_object_id) do
    :ok
  end

  @spec key_id_valid(T.key_id) :: :ok | {:error, String.t}
  defp key_id_valid(_key_id) do
    :ok
  end

  @spec keys_valid([T.key]) :: :ok | {:error, String.t}
  defp keys_valid(_keys) do
    :ok
  end

  @spec key_ids_valid([T.key_id]) :: ok | {:error, String.t}
  defp key_ids_valid(_key_ids) do
    :ok
  end

end
