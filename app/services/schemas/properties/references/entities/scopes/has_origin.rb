# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        module Scopes
          # A concern for scopes that can customize their origin.
          module HasOrigin
            extend ActiveSupport::Concern

            included do
              # @!attribute [rw] origin
              # @return [String]
              attribute :origin, :string, default: "self"

              validate :origin_is_correct!
            end

            # @api private
            # @return [void]
            def origin_is_correct!
              errors.add :origin, "is invalid" unless Types::Origin.valid?(origin)
            end
          end
        end
      end
    end
  end
end
