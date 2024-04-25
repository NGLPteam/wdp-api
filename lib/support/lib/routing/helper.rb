# frozen_string_literal: true

module Support
  module Routing
    # Helpers for working with Rails routing.
    module Helper
      extend ActiveSupport::Concern

      # @see Support::Routing::BuildURLOptions
      # @param [String] endpoint
      def url_options_for(endpoint)
        Support::System["routing.build_url_options"].(endpoint).value!
      end
    end
  end
end
