# frozen_string_literal: true

module Testing
  # @api private
  module Types
    include Dry.Types

    HTTPMethod = String.enum("HEAD", "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
  end
end
