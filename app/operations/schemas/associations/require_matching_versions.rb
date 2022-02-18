# frozen_string_literal: true

module Schemas
  module Associations
    # @see Schemas::Associations::FindMatchingVersions
    class RequireMatchingVersions
      include Dry::Monads[:result]
      include WDPAPI::Deps[find_matching_versions: "schemas.associations.find_matching_versions"]

      # @param [Schemas::Associations::Association] association
      # @return [Dry::Monads::Success<SchemaVersion>]
      # @return [Dry::Monads::Failure(:no_match, Schemas::Associations::Association)]
      def call(association)
        versions = find_matching_versions.call(association).value_or([])

        return Failure[:no_match, association] if versions.blank?

        Success versions
      end
    end
  end
end
