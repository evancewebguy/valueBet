defmodule ValueBetWeb.Router do
  use ValueBetWeb, :router

  import ValueBetWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ValueBetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ValueBetWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/games", HomeLive.Index, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", ValueBetWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:valueBet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ValueBetWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ValueBetWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ValueBetWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end



  scope "/", ValueBetWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ValueBetWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/users/list", UsersLive, :all
      live "/users/:id", UsersLive, :view_permissions
      live "/users/:id/add", UsersLive, :add_permissions
      live "/users/:id/remove", UsersLive, :remove_permissions

      # bet
      # live "/mybets", HomeLive.Index, :index


      #games
      live "/gamesa", GamesLive

      #competition
      live "/competitions", CompetitionLive.Index, :index
      live "/competitions/new", CompetitionLive.Index, :new
      live "/competitions/:id/edit", CompetitionLive.Index, :edit

      live "/competitions/:id", CompetitionLive.Show, :show
      live "/competitions/:id/show/edit", CompetitionLive.Show, :edit

      #league
      live "/leagues", LeagueLive.Index, :index
      live "/leagues/new", LeagueLive.Index, :new
      live "/leagues/:id/edit", LeagueLive.Index, :edit

      live "/leagues/:id", LeagueLive.Show, :show
      live "/leagues/:id/show/edit", LeagueLive.Show, :edit

      #teams
      live "/teams", TeamLive.Index, :index
      live "/teams/new", TeamLive.Index, :new
      live "/teams/:id/edit", TeamLive.Index, :edit

      live "/teams/:id", TeamLive.Show, :show
      live "/teams/:id/show/edit", TeamLive.Show, :edit

      #fixtures
      live "/fixtures", FixtureLive.Index, :index
      live "/fixtures/new", FixtureLive.Index, :new
      live "/fixtures/:id/edit", FixtureLive.Index, :edit

      live "/fixtures/:id", FixtureLive.Show, :show
      live "/fixtures/:id/show/edit", FixtureLive.Show, :edit


      #bets
      live "/bets", BetLive.Index, :index
      # live "/bets/new", BetLive.Index, :new
      # live "/bets/:id/edit", BetLive.Index, :edit

      live "/bets/:id", BetLive.Show, :show
      # live "/bets/:id/show/edit", BetLive.Show, :edit

    end
  end

  scope "/", ValueBetWeb do
    pipe_through [:browser]


    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ValueBetWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end


end
