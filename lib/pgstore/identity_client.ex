defmodule Memesmail.Pgstore.IdentityClient do
  @moduledoc """
  Library for retrieving identity data
  """

  alias Memesmail.Model.Types, as: T
  alias Memesmail.Pgstore.Server, as: Server
  alias Memesmail.Pgstore.Queries, as: Queries

  @spec user_identity(T.user) :: {:ok, T.user_identity} | {:error, String.t}
  def user_identity(user) do
    Queries.load_user_identity_query
    |> (&Postgrex.prepare!(Server.server_name, "user_identity", &1)).()
    |> (
         &Postgrex.execute!(
           Server.server_name,
           &1,
           [{user}]
         ).rows).()
    |> hd
    |> hd
    |> (fn ({user_info}) -> {:ok, user_info} end).()
  end

  @spec user_identity_history(T.user) :: {:ok, [T.user_identity]} | {:error, String.t}
  def user_identity_history(user) do
    Queries.load_user_identity_query
    |> (&Postgrex.prepare!(Server.server_name, "user_identity_history", &1)).()
    |> (
         &Postgrex.execute!(
           Server.server_name,
           &1,
           [{user}]
         ).rows).()
    |> hd
    |> hd
    |> (fn (hists) -> {:ok, Enum.map(hists, fn({hist}) -> hist end)} end).()
  end

  @spec server_identity() :: {:ok, T.server_identity} | {:error, String.t}
  def server_identity() do
    Queries.load_server_identity_query
    |> (&Postgrex.query!(Server.server_name, &1, []).rows).()
    |> hd
    |> hd
    |> (fn ({server_info}) -> {:ok, server_info} end).()
  end

  @spec server_identity_history() :: {:ok, [T.server_identity]} | {:error, String.t}
  def server_identity_history() do
    Queries.load_server_identity_history_query
    |> (&Postgrex.query!(Server.server_name, &1, []).rows).()
    |> Enum.map(fn(row) -> hd(elem(row,0)) end)
    |> (fn (server_hist) -> {:ok, server_hist} end).()
  end

end
