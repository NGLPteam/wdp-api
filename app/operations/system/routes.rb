# frozen_string_literal: true

module System
  # URL Helper for generating routes on the API.
  class Routes
    include Dry::Core::Memoizable
    include Rails.application.routes.url_helpers

    # @!attribute [r] default_url_options
    # @return [Hash]
    memoize def default_url_options
      LocationsConfig.api_url_options
    end
  end
end
