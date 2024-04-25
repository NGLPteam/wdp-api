# frozen_string_literal: true

module Schemas
  module Associations
    module Operations
      extend ActiveSupport::Concern

      # @see Schemas::Associations::FindAllMatchingVersions
      # @param [<Schemas::Associations::Association>] associations
      # @return [<SchemaVersion>]
      def find_all_matching_versions_for(associations)
        MeruAPI::Container["schemas.associations.find_all_matching_versions"].call(associations).value_or([])
      end

      # @see Schemas::Associations::FindMatchingVersions
      # @param [Schemas::Associations::Association] association
      # @return [<SchemaVersion>]
      def find_matching_versions_for(association)
        MeruAPI::Container["schemas.associations.find_matching_versions"].call(association).value_or([])
      end

      # @see Schemas::Associations::RequireAllMatchingVersions
      # @param [<Schemas::Associations::Association>] associations
      # @return [Dry::Monads::Success<SchemaVersion>]
      # @return [Dry::Monads::Failure(:no_match, <Schemas::Associations::Association>)]
      def require_all_matching_versions_for(associations)
        MeruAPI::Container["schemas.associations.require_all_matching_versions"].call(associations)
      end

      # @see Schemas::Associations::RequireMatchingVersions
      # @param [Schemas::Associations::Association] association
      # @return [Dry::Monads::Success<SchemaVersion>]
      # @return [Dry::Monads::Failure(:no_match, Schemas::Associations::Association)]
      def require_matching_versions_for(association)
        MeruAPI::Container["schemas.associations.require_matching_versions"].call(association)
      end
    end
  end
end
