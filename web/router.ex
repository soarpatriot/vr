defmodule Vr.Router do
  use Vr.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do  
    plug Mellon, validator: {Vr.Validation, :validate, []}, header: "api-token"
  end

  scope "/", Vr do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/login", SessionController, :create
  end
  scope "/", Vr do
    pipe_through :api
    pipe_through :authenticated
    get "/validate", SessionController, :validate
  end

end
