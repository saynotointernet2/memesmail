defmodule Memesmail.Pgstore.UserClient do
  @moduledoc """
  Define the client data interface behavior
  """

  alias Memesmail.Pgstore.Server, as: Server
  alias Memesmail.Pgstore.Queries, as: Queries
  alias Memesmail.Model.Types, as: Types

  @doc """
  Get user auth token
  """
  @spec get_user_login_token(binary) :: {atom, binary}
  def get_user_login_token(user) do
    Queries.get_user_login_token
    |> (&Postgrex.prepare!(Server.server_name, "get_user_login_token", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, &1}).()
  end

  @doc """
  Create new user
  """
  @spec create_new_user(binary, binary, binary) :: {atom, binary}
  def create_new_user(user_id, login_token, storage_root) do
     Queries.create_new_user
     |> (&Postgrex.prepare!(Server.server_name, "create_new_user", &1)).()
     |> (&Postgrex.execute!(Server.server_name, &1, [ {user_id}, {login_token}, {storage_root}]).rows).()
     |> (&{:ok, &1}).()
  end

end