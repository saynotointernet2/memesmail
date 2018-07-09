defmodule Memesmail.Web.Router do
  use Plug.Router

  require Logger

  alias Memesmail.Web.User, as: User

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(_opts) do
    :ok
  end

  post "/v0/user/init_login" do
    IO.puts("fuck1")
    conn2 = User.init_login(conn)
    IO.puts("fuck2")
    IO.puts(conn2.resp_body)
    IO.puts("fuck3")
    send_resp(conn2)
  end

  post "/v0/user/login" do
    conn
    |> User.login
    |> send_resp
  end


  post "/v0/user/logout" do
    conn
    |> User.logout
    |> send_resp
  end

  post "/v0/user/register_user" do
    conn
    |> User.register_user
    |> send_resp
  end

  match(_) do
    send_resp(conn, 404, "")
  end

end


#defmodule Memesmail.Web.Router do

#  pipeline :api do
#    plug :accepts, ["json"]
#  end

#  scope "/v0", Memesmail do
#    pipe_through :api
#
#    post "/user/init", UserController, :init_login
#    post "/user/login", UserController, :do_login
#    post "/user/logout", UserController, :logout
#    post "/user/register", UserController, :register
#
#  end
#end

