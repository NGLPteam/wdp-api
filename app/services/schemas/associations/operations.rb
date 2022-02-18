# frozen_string_literal: true

module Schemas
  module Associations
    module Operations
      extend ActiveSupport::Concern

      # @see Schemas::Associations::FindAllMatchingVersions
      # @param [<Schemas::Associations::Association>] associations
      # @return [<SchemaVersion>]
      def find_all_matching_versions_for(associations)
        WDPAPI::Container["schemas.associations.find_all_matching_versions"].call(associations).value_or([])
      end

      # @see Schemas::Associations::FindMatchingVersions
      # @param [Schemas::Associations::Association] association
      # @return [<SchemaVersion>]
      def find_matching_versions_for(association)
        WDPAPI::Container["schemas.associations.find_matching_versions"].call(association).value_or([])
      end
    end
  end
end
