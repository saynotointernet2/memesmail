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
  @spec get_user_login_token(Types.user) :: {:ok, Types.login_token} | {:error, String.t}
  def get_user_login_token(user) do
    Queries.get_user_login_token_query
    |> (&Postgrex.prepare!(Server.server_name, "get_user_login_token", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [{user}]).rows).()
    |> hd
    |> hd
    |> (&{:ok, elem(&1, 0)}).()
  end

  @doc """
  Create new user
  """
  @spec create_new_user(Types.user, Types.login_token, Types.body, Types.user_identity) :: :ok | {:error, String.t}
  def create_new_user(user_id, login_token, storage_root, identity) do
     Queries.create_new_user_query
     |> (&Postgrex.prepare!(Server.server_name, "create_new_user", &1)).()
     |> (&Postgrex.execute!(Server.server_name, &1, [ {user_id}, {login_token}, {storage_root}, {identity}]).rows).()
     :ok
  end

  @spec update_identity(Types.user, Types.user_identity) :: :ok | {:error, String.t}
  def update_identity(user, new_identity) do
    Queries.update_user_identity_query
    |> (&Postgrex.prepare!(Server.server_name, "update_user_identity", &1)).()
    |> (&Postgrex.execute!(Server.server_name, &1, [ {user}, {new_identity} ])).()
    :ok
  end

end