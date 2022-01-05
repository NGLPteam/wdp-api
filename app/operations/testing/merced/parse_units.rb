# frozen_string_literal: true

module Testing
  module Merced
    # Read and parse the JSON for Merced units.
    #
    # @api private
    # @operation
    class ParseUnits
      include Dry::Monads[:try]
      prepend HushActiveRecord

      UNITS_PATH = Rails.root.join("vendor/ucm/ucm_units.json")

      # @return [Dry::Monads::Success<ActiveSupport::HashWithIndifferentAccess>]
      def call
        Try do
          raw_content = UNITS_PATH.read

          parsed = JSON.parse raw_content

          { parsed: parsed }.with_indifferent_access.fetch :parsed
        end.to_result
      end
    end
  end
end
