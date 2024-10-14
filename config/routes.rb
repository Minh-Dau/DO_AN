Rails.application.routes.draw do
  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # User registration routes
  get "register", to: "home#register", as: :register
  post "register", to: "home#create", as: :register_create

  # Password recovery routes
  get "laylaimatkhau", to: "home#laylaimatkhau", as: :password_reset_request
  post "laylaimatkhau", to: "home#laylaimatkhau_submit"

  get "quenmatkhau", to: "home#quenmatkhau", as: :password_recovery
  post "quenmatkhau", to: "home#quenmatkhau_submit"

  # Login and Logout routes
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Default root route to login
  root "home#register"
end
