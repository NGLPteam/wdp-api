# frozen_string_literal: true

module Protocols
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    URL = String.constrained(http_uri: true)
  end
end
