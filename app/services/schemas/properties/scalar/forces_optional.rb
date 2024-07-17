# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      module ForcesOptional
        extend ActiveSupport::Concern

        # @note This has been forced to always be false.
        # @return [Boolean]
        def required
          false
        end

        alias required? required

        def required=(*); end
      end
    end
  end
end
