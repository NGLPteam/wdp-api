# frozen_string_literal: true

module Schemas
  module Properties
    # Parse a stringifed property path into its component parts.
    class ParsePath
      include Dry::Monads[:result]

      # @api private
      PATTERN = /\Aprops\.(?<path>[^#]+)(?:#(?<type>[^#]+))?\z/

      # @param [String] input
      # @return [Dry::Monads::Success(Schemas::Properties::Path)]
      # @return [Dry::Monads::Failure(:unparseable_path, Schemas::Properties::InvalidPath)]
      def call(input)
        match = PATTERN.match input

        return unparseable!(input, "Does not match pattern") unless match

        type = match[:type].presence || "unknown"

        path = Schemas::Properties::Path.new(path: match[:path], type:)

        Success path
      end

      private

      # @param [Object] input
      # @param [String] reason
      def unparseable!(input, reason)
        Schemas::Properties::InvalidPath.new(input:, reason:).to_monad
      end
    end
  end
end
