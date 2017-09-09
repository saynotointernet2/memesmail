defmodule PgStore.Server do
  @moduledoc """
  Used to connect to the user database.
  """

  @name PgStoreServer
  def server_name, do: @name

  #TODO Use dbConnections interface for prepared queries.
  def start_link do
    config = IO.inspect(Application.get_env(:memesmail, Data))
    Postgrex.start_link(
      hostname: config[:hostname],
      username: config[:username],
      password: config[:password],
      database: config[:dbName],
      name: @name)
  end

end