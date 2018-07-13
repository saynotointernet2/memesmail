defmodule Memesmail.Web.User do
  @moduledoc """
  Plug implementations for user calls
  """

  alias Memesmail.Service.User, as: User
  alias Memesmail.Web.Utils, as: Utils

  import Plug.Conn

  @spec init_login(Conn.t) :: Conn.t
  def init_login(conn) do
    with {:ok, user} <- Utils.cookie_username(conn),
         %{"cnonce" => cnonce} <- conn.body_params,
         {:ok, nonce} <- User.init_login(user, cnonce)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{nonce: Base.encode64(nonce)}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec login(Conn.t) :: Conn.t
  def login(conn) do
    with {:ok, user} <- Utils.cookie_username(conn),
         {:ok, token} <- Utils.cookie_session_token(conn),
         {:ok, root_object} <- User.login(user, token)
      do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, Poison.encode!(%{root: root_object}))
    else
      _ -> resp(conn, 400, "error")
    end
  end

  @spec logout(Conn.t) :: Conn.t
  def logout(conn) do
    with {:ok, user} <- Utils.cookie_username(conn),
         {:ok, token} <- Utils.cookie_session_token(conn),
         :ok <- User.logout(user, token)
      do
      conn
      |> resp(200, "success")
    else
      _ -> resp(conn, 400, "error")
    end
  end


  @spec register_user(Conn.t) :: Conn.t
  def register_user(conn) do
    with %{:username => user, :register_token => reg, :login_token => token, :root => root} <- conn.body_params,
         :ok <- User.register_user(user, reg, token, root)
      do
      conn
      |> resp(200, "success")
    else
      _ -> resp(conn, 400, "error")
    end
  end

end
