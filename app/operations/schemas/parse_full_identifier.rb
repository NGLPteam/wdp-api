# frozen_string_literal: true

module Schemas
  # A service to turn `"nglp.article"` or `"nglp:article:1.3.2"` into `["nglp", "article"]`.
  class ParseFullIdentifier
    include Dry::Monads[:result]

    PATTERN = /\A(?<namespace>[^.:]+)[.:](?<id>[^.:]+)(?::[^:]+)?\z/

    # @param [String] full_identifier
    # @return [Dry::Monads::Result::Success(String, String)]
    # @return [Dry::Monads::Result::Failure(:invalid_identifier, String)]
    def call(full_identifier)
      match = PATTERN.match full_identifier

      return Failure[:invalid_identifier, identifier] if match.blank?

      Success[match[:namespace], match[:id]]
    end
  end
end
