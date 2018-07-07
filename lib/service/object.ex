defmodule Memesmail.Service.Object do
  @moduledoc """
  Object-Access implementation
  """

  @behaviour Memesmail.Model.Object

#  alias Memesmail.Model.Types, as: T
  alias Memesmail.Policy.Object, as: Policy
  alias Memesmail.Session.Client, as: Session
#  alias Memesmail.Pgstore.UserClient, as: UserStore
  alias Memesmail.Pgstore.ObjectClient, as: ObjectStore

  def store_object(user, token, body, keys) do
    with :ok <- Policy.store_object(user, token, body, keys),
         :ok <- Session.verify_session_token(user, token),
         {:ok, stored_ids} <- ObjectStore.store_object(user, body, keys)
      do
      {:ok, stored_ids}
    else
      :invalid -> {:error, "Token provided by user failed to verify."}
      :error -> {:error, "Failed to store object"}
    end
  end

  #  @spec add_keys(T.user, T.session_token, binary, list) :: {:ok, [T.key_id]} | {:error, String.t}
  def add_keys(user, token, object_id, keys) do
    with :ok <- Policy.add_keys(user, token, object_id, keys),
         :ok <- Session.verify_session_token(user, token),
         {:ok, key_ids} <- ObjectStore.add_keys(user, object_id, keys)
      do
      {:ok, key_ids}
    else
      :invalid -> {:error, "Token provided by user failed to verify."}
      :error -> {:error, "Failed to add keys to object"}
    end
  end

  #  @spec edit_body(T.user, T.session_token, binary, binary) :: :ok | {:error, String.t}
  def edit_body(user, token, object_id, body) do
    with :ok <- Policy.edit_body(user, token, object_id, body),
         :ok <- Session.verify_session_token(user, token),
         :ok <- ObjectStore.edit_body(user, object_id, body)
      do
      :ok
    else
      :invalid -> {:error, "Token provided by user failed to verify."}
      :error -> {:error, "Failed to edit body of object"}
    end
  end

  #  @spec edit_object(T.user, T.session_token, binary, binary, list) :: {:ok, [T.key_id]} | {:error, String.t}
  def edit_object(user, token, object_id, body, keys) do
    with :ok <- Policy.edit_object(user, token, object_id, body, keys),
         :ok <- Session.verify_session_token(user, token),
         {:ok, key_ids} <- ObjectStore.edit_object(user, object_id, body, keys)
      do
      {:ok, key_ids}
    else
      :invalid -> {:error, "Token provided by user failed to verify."}
      :error -> {:error, "Failed to edit object"}
    end
  end

  #  @spec edit_key(T.user, T.session_token, binary, binary, binary) :: :ok | {:error, String.t}
  def edit_key(user, token, object_id, key_id, key) do
    with :ok <- Policy.edit_key(user, token, object_id, key_id, key),
         :ok <- Session.verify_session_token(user, token),
         :ok <- ObjectStore.edit_object(user, object_id, key_id, key)
      do
      :ok
    else
      :invalid -> {:error, "Token provided by user failed to verify."}
      :error -> {:error, "Failed to edit object key"}
    end
  end

  #  @spec load_object_with_key(T.user, T.session_token, binary, binary) :: {:ok, T.object_key} | {:error, String.t}
  def load_object_with_key(user, token, object_id, key_id) do
    with :ok <- Policy.load_object_with_key(user, token, object_id, key_id),
         :ok <- Session.verify_session_token(user, token),
         {:ok, object_with_key} <- ObjectStore.load_object_with_key(user, object_id, key_id)
      do
      {:ok, object_with_key}
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to load object and key"}
    end
  end


  #  @spec load_object_full(T.user, T.session_token, binary) :: {:ok, Type.object_full} | {:error, String.t}
  def load_object_full(user, token, object_id) do
    with :ok <- Policy.load_object_full(user, token, object_id),
         :ok <- Session.verify_session_token(user, token),
         {:ok, full_object} <- ObjectStore.load_object_full(user, object_id)
      do
      {:ok, full_object}
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to load full object"}
    end
  end

  #  @spec load_all_ids(T.user, T.session_token) :: {:ok, [T.object_id]} | {:error, String.t}
  def load_all_ids(user, token) do
    with :ok <- Policy.load_all_ids(user, token),
         :ok <- Session.verify_session_token(user, token),
         {:ok, ids} <- ObjectStore.load_all_ids(user)
      do
      {:ok, ids}
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to load all object ids"}
    end
  end

  #  @spec load_root_object(T.user, T.session_token) :: {:ok, T.body} | {:error, String.t}
  def load_root_object(user, token) do
    with :ok <- Policy.load_root_object(user, token),
         :ok <- Session.verify_session_token(user, token),
         {:ok, root_object} <- ObjectStore.load_root_object(user)
      do
      {:ok, root_object}
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to load root object"}
    end
  end

  #  @spec remove_object(T.user, T.session_token, binary) :: :ok | {:error, String.t}
  def remove_object(user, token, object_id) do
    with :ok <- Policy.remove_object(user, token, object_id),
         :ok <- Session.verify_session_token(user, token),
         :ok <- ObjectStore.remove_object(user, object_id)
      do
      :ok
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to remove object"}
    end
  end

  #  @spec remove_keys(T.user, T.session_token, binary, list) :: :ok | {:error, String.t}
  def remove_keys(user, token, object_id, key_ids) do
    with :ok <- Policy.remove_keys(user, token, object_id, key_ids),
         :ok <- Session.verify_session_token(user, token),
         :ok <- ObjectStore.remove_keys(user, object_id, key_ids)
      do
      :ok
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to remove object keys"}
    end
  end


#  @spec store_root_object(T.user, T.session_token, T.body) :: :ok | {:error, String.t}
  def store_root_object(user, token, root_object) do
    with :ok <- Policy.store_root_object(user, token, root_object),
         :ok <- Session.verify_session_token(user, token),
         :ok <- ObjectStore.store_root_object(user, root_object)
      do
      :ok
    else
      :invalid -> {:error, "token provided by user failed to verify."}
      :error -> {:error, "failed to store root object"}
    end
  end

end
