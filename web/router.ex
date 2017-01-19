defmodule Vr.Router do
  use Vr.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Vr do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end
end
