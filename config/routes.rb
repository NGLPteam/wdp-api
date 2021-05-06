# frozen_string_literal: true

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  get "/ping", to: "status#ping"

  root to: "status#root"
end
