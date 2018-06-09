defmodule Memesmail.Web.Router do
  use Plug.Router

  alias Memesmail.Web.Plugs, as: Plugs

  plug Corsica, max_age: 600, origins: "*"
  plug Plugs.Session

  plug :match
  plug :dispatch

  def init(_opts) do
    :ok
  end

  post "/v0/user/init" do
    send_resp(conn, 200, encode(App.users))
  end

  post "/v0/user/login" do
    send_resp(conn, 200, encode(App.users))
  end


  post "/v0/user/logout" do
    send_resp(conn, 200, encode(App.users))
  end

  post "/v0/user/register" do
    send_resp(conn, 200, encode(App.users))
  end

  match(_) do
    send_resp(conn, 404, "")
  end

  defp encode(users) do
    Poison.encode!(users)
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

