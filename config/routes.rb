# frozen_string_literal: true

Rails.application.routes.draw do
  mount WDPAPI::TusUploader, at: "/files"

  mount WDPAPI::SidekiqFrontend, at: "/sekrit/sidekiq"

  post "/graphql", to: "graphql#execute"

  get "/ping", to: "status#ping"

  root to: "status#root"
end
