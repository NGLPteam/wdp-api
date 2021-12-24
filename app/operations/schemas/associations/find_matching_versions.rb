# frozen_string_literal: true

module Schemas
  module Associations
    # Given an {Schemas::Associations::Association association}, return all matching
    # {SchemaVersion schema versions} that satisfy its version requirements.
    class FindMatchingVersions
      include Dry::Monads[:result]

      # @param [Schemas::Associations::Association] association
      # @return [Dry::Monads::Success<SchemaVersion>]
      def call(association)
        versions = SchemaVersion.by_tuple(association.namespace, association.identifier).by_position.select do |schema|
          association.version_satisfied_by? schema.gem_version
        end

        Success versions
      end
    end
  end
end
