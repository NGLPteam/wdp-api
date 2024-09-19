# frozen_string_literal: true

module Harvesting
  module MetadataMappings
    class AssignManyByIdentifier
      include Dry::Monads[:result, :do]

      include MeruAPI::Deps[
        assign: "harvesting.metadata_mappings.assign",
      ]

      # @param [HarvestTarget] base_entity
      # @return [Dry::Monads::Result]
      def call(...)
        assign.many_by_identifier(...)
      end
    end
  end
end
