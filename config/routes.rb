Rails.application.routes.draw do
  # Blog/Writing
  resources :articles, only: [ :index, :show ]

  # OmniAuth callback routes (for user sign-in via GitHub/Google/Apple)
  get "/auth/:provider/callback", to: "sessions#oauth"
  post "/auth/:provider/callback", to: "sessions#oauth" # Some providers use POST
  get "/auth/failure", to: "sessions#failure"

  # Authentication routes
  resource :session
  resource :registration, only: [ :new, :create ]
  resource :profile, only: [ :show, :edit, :update, :destroy ]
  resources :passwords, param: :token

  # API token management
  resources :api_tokens, only: [ :index, :new, :create, :destroy ]

  # Legal pages
  get "/privacy", to: "legal#privacy"
  get "/terms", to: "legal#terms"
  get "/support", to: "legal#support"

  # Admin panel
  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index", as: :dashboard

    resources :users, only: [ :index, :show, :destroy ] do
      member do
        post :make_admin
        delete :remove_admin
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Landing page
  root "landing#index"
end
