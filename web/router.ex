defmodule Vr.Router do
  use Vr.Web, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do  
    plug Mellon, validator: {Vr.Validation, :validate, []}, header: "api-token"
  end

  scope "/", Vr do
    pipe_through :api
    get "/posts", PostController, :index
    get "/highlights/lastest", HighlightController, :lastest 
    resources "/highlights", HighlightController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    post "/login", SessionController, :create
  end
  scope "/", Vr do
    pipe_through :api
    pipe_through :authenticated
    get "/posts/my", PostController, :my
    resources "/posts", PostController, except: [:new, :edit, :index]
    resources "/files", FileController, except: [:new, :edit]
    get "/validate", SessionController, :validate
  end
  
  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes()
  end
end
