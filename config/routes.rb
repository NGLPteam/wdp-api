# frozen_string_literal: true

Rails.application.routes.draw do
  mount Middleware::TusUploader, at: "/files"

  mount GoodJob::Engine => "/sekrit/good_job"

  resources :downloads, only: %i[show]

  resource :identity, path: "whoami", only: %i[show]

  post "/graphql", to: "graphql#execute"

  scope "/graphql" do
    resources :example_queries, only: %i[index]
  end

  get "/ping", to: "status#ping"

  get "/up", to: "status#ping", as: :health_check

  root to: "status#root"
end
