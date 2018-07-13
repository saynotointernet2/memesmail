defmodule Memesmail.Web.Utils do
  @moduledoc """
  Connection utilities
  """

  alias Memesmail.Model.Types, as: T

  @spec cookie_username(Conn.t) :: {:ok, T.user} | {:error, String.t}
  def cookie_username(conn) do
    with %{"memes.user" => user} <- conn.req_cookies
      do
      {:ok, user}
    else
      _ -> {:error, "Failed to extract username from request cookie"}
    end
  end

  @spec cookie_session_token(Conn.t) :: {:ok, T.session_token} | {:error, String.t}
  def cookie_session_token(conn) do
    with %{"memes.session" => session} <- conn.req_cookies
      do
      {:ok, session}
    else
      _ -> {:error, "Failed to extract session from request cookie"}
    end
  end

end
