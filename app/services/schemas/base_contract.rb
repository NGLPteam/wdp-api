# frozen_string_literal: true

module Schemas
  class BaseContract < ApplicationContract
    include WDPAPI::Deps[
      matches_models: "models.matches"
    ]

    config.types = Schemas::Properties::Types::Registry
  end
end
