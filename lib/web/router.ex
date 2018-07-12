defmodule Memesmail.Web.Router do
  use Plug.Router

  require Logger

  alias Memesmail.Web.User, as: User
  alias Memesmail.Web.Object, as: Object

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(_opts) do
    :ok
  end

  #
  # USER API
  #
  post "/v0/user/init_login" do
    conn
    |> User.init_login
    |> send_resp
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

  #
  # OBJECT API
  #
  post "/v0/object/store_object" do
    conn
    |> Object.store_object
    |> send_resp
  end

  post "/v0/object/add_keys" do
    conn
    |> Object.add_keys
    |> send_resp
  end


  post "/v0/object/edit_body" do
    conn
    |> Object.edit_body
    |> send_resp
  end

  post "/v0/object/edit_object" do
    conn
    |> Object.edit_object
    |> send_resp
  end

  post "/v0/object/edit_key" do
    conn
    |> Object.edit_key
    |> send_resp
  end

  post "/v0/object/load_object_with_key" do
    conn
    |> Object.load_object_with_key
    |> send_resp
  end

  post "/v0/object/load_object_full" do
    conn
    |> Object.load_object_full
    |> send_resp
  end

  post "/v0/object/load_all_ids" do
    conn
    |> Object.load_all_ids
    |> send_resp
  end

  post "/v0/object/load_root_object" do
    conn
    |> Object.load_root_object
    |> send_resp
  end

  post "/v0/object/remove_object" do
    conn
    |> Object.remove_object
    |> send_resp
  end

  post "/v0/object/remove_keys" do
    conn
    |> Object.remove_keys
    |> send_resp
  end

  post "/v0/object/store_root_object" do
    conn
    |> Object.store_root_object
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

