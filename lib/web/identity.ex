defmodule Memesmail.Web.Identity do
  @moduledoc """
  Web implementations for identity API
  """
  alias Memesmail.Service.Identity, as: Identity

  import Plug.Conn

  @spec user_identity(Conn.t) :: Conn.t
  def user_identity(conn) do
    with %{username: user} <- conn.body_params,
         {:ok, info} <- Identity.user_identity(user)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{user_identity: info}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec user_identity_history(Conn.t) :: Conn.t
  def user_identity_history(conn) do
    with %{username: user} <- conn.body_params,
         {:ok, info} <- Identity.user_identity_history(user)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{user_identity_history: info}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec server_identity(Conn.t) :: Conn.t
  def server_identity(conn) do
    with %{} <- conn.body_params,
         {:ok, info} <- Identity.server_identity()
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{server_identity: info}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec server_identity_history(Conn.t) :: Conn.t
  def server_identity_history(conn) do
    with %{} <- conn.body_params,
         {:ok, info} <- Identity.server_identity_history()
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{server_identity_history: info}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

end
