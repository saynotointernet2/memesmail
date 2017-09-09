defmodule Memesmail.Web.Router do
  use Memesmail.Web.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v0", Memesmail do
    pipe_through :api

    post "/user/init", UserController, :init_login
    post "/user/login", UserController, :do_login
    post "/user/logout", UserController, :logout
    post "/user/register", UserController, register

  end
end
