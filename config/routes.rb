# frozen_string_literal: true

Rails.application.routes.draw do
  mount Middleware::TusUploader, at: "/files"

  mount Middleware::PGHeroFrontend, at: "/sekrit/pghero"

  mount Middleware::SidekiqFrontend, at: "/sekrit/sidekiq"

  resource :identity, path: "whoami", only: %i[show]

  post "/graphql", to: "graphql#execute"

  scope "/graphql" do
    resources :example_queries, only: %i[index]
  end

  get "/ping", to: "status#ping"

  root to: "status#root"
end
