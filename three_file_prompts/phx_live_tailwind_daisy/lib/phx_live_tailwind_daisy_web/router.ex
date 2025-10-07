defmodule PhxLiveTailwindDaisyWeb.Router do
  use PhxLiveTailwindDaisyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhxLiveTailwindDaisyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :inertia do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxLiveTailwindDaisyWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/demo", DemoLive
  end

  scope "/inertia", PhxLiveTailwindDaisyWeb do
    pipe_through :inertia

    get "/counter", InertiaCounterController, :index
    post "/counter/increment", InertiaCounterController, :increment
    post "/counter/decrement", InertiaCounterController, :decrement
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxLiveTailwindDaisyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phx_live_tailwind_daisy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhxLiveTailwindDaisyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
