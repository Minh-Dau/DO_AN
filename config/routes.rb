Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Authentication routes
  get "login", to: "home#login", as: "login"
  post "login", to: "home#login_process", as: "login_process"
  # Registration routes
  get "register", to: "home#register", as: "register"
  post "register", to: "home#create", as: "register_create"

  get "laylaimatkhau", to:"home#laylaimatkhau", as:"laylaimatkhau"
  post "laylaimatkhau", to:"home#laylaimatkhau"

  get "quenmatkhau", to:"home#quenmatkhau", as:"quenmatkhau"
  post "quenmatkhau", to:"home#quenmatkhau"

  # Route for the home action
  get "home", to: "home#home", as: "home"

  # Default route to login
  root "home#login"
end
