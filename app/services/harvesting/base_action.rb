# frozen_string_literal: true

module Harvesting
  # @abstract
  class BaseAction
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      wrap_middleware: "harvesting.middleware.wrap",
    ]

    def call(*); end
  end
end
