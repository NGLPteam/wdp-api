# frozen_string_literal: true

module Support
  module Networking
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      RetryCount = Integer.constrained(gt: 0, lt: 11)

      URL = String.constrained(http_uri: true)
    end
  end
end
