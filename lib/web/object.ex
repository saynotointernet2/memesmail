defmodule Memesmail.Web.Object do
  @moduledoc """
  Plug implementations for object access calls
  """

  import Plug.Conn
  alias Memesmail.Service.Object, as: Object

  @spec store_object(Conn.t) :: Conn.t
  def store_object(conn) do
    with %{"username" => user, "token" => token, "body" => body, "keys" => keys} <- conn.body_params,
         {:ok, {obj_id, key_ids}} <- Object.store_object(user, token, body, keys)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(
           200,
           Poison.encode!(%{object_id: obj_id, key_ids: key_ids})
         )
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec add_keys(Conn.t) :: Conn.t
  def add_keys(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id, "keys" => keys} <- conn.body_params,
         {:ok, key_ids} <- Object.add_keys(user, token, object_id, keys)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(
           200,
           Poison.encode!(%{key_ids: key_ids})
         )
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec edit_body(Conn.t) :: Conn.t
  def edit_body(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id, "body" => body} <- conn.body_params,
         :ok <- Object.edit_body(user, token, object_id, body)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{response: "success"}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec edit_object(Conn.t) :: Conn.t
  def edit_object(conn) do
    with %{
           "username" => user,
           "token" => token,
           "object_id" => object_id,
           "body" => body,
           "keys" => keys
         } <- conn.body_params,
         {:ok, key_ids} <- Object.edit_object(user, token, object_id, body, keys)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(
           200,
           Poison.encode!(%{key_ids: key_ids})
         )
    else
      _ -> resp(conn, 400, "error")
    end
  end


  @spec edit_key(Conn.t) :: Conn.t
  def edit_key(conn) do
    with %{
           "username" => user,
           "token" => token,
           "object_id" => object_id,
           "key_id" => key_id,
           "key" => key
         } <- conn.body_params,
         :ok <- Object.edit_key(user, token, object_id, key_id, key)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{response: "success"}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec load_object_with_key(Conn.t) :: Conn.t
  def load_object_with_key(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id, "key_id" => key_id} <- conn.body_params,
         {:ok, {body, key}} <- Object.load_object_with_key(user, token, object_id, key_id)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{body: body, key: key}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec load_object_full(Conn.t) :: Conn.t
  def load_object_full(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id} <- conn.body_params,
         {:ok, {body, key_id_pairs}} <- Object.load_object_full(user, token, object_id)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{body: body, keys: Enum.map(key_id_pairs, fn ({id, key}) -> %{id => key} end)}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec load_all_ids(Conn.t) :: Conn.t
  def load_all_ids(conn) do
    with %{"username" => user, "token" => token} <- conn.body_params,
         {:ok, obj_ids} <- Object.load_all_ids(user, token)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{ids: obj_ids}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec load_root_object(Conn.t) :: Conn.t
  def load_root_object(conn) do
    with %{"username" => user, "token" => token} <- conn.body_params,
         {:ok, root_object} <- Object.load_root_object(user, token)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{root: root_object}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec remove_object(Conn.t) :: Conn.t
  def remove_object(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id} <- conn.body_params,
         :ok <- Object.remove_object(user, token, object_id)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{response: "success"}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec remove_keys(Conn.t) :: Conn.t
  def remove_keys(conn) do
    with %{"username" => user, "token" => token, "object_id" => object_id, "key_ids" => key_ids} <- conn.body_params,
         :ok <- Object.remove_keys(user, token, object_id, key_ids)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{response: "success"}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec store_root_object(Conn.t) :: Conn.t
  def store_root_object(conn) do
    with %{"username" => user, "token" => token, "root" => root} <- conn.body_params,
         :ok <- Object.store_root_object(user, token, root)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{response: "success"}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

end
