defmodule Vr.Router do
  use Vr.Web, :router
  use Coherence.Router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  # Add this block
  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do  
    plug Mellon, validator: {Vr.Validation, :validate, []}, header: "api-token"
  end
  scope "/", Vr do
    pipe_through :api
    pipe_through :authenticated
    get "/posts/my", PostController, :my
    resources "/posts", PostController, except: [:new, :edit, :index, :show]
    resources "/assets", AssetController, except: [:new, :edit]
    resources "/covers", CoverController, except: [:new, :edit]
    get "/validate", SessionController, :validate
  end


  scope "/", Vr do
    pipe_through :api
    get "/posts", PostController, :index
    get "/posts/:id", PostController, :show 
    get "/highlights/lastest", HighlightController, :lastest 
    resources "/highlights", HighlightController, except: [:new, :edit]
    get "/users/activation", UserController, :activation
    resources "/users", UserController, except: [:new, :edit]
    resources "/parts", PartController, except: [:new, :edit]
    post "/login", SessionController, :create
  end
  scope "/admin", ExAdmin do
    pipe_through :protected
    admin_routes()
  end



end
