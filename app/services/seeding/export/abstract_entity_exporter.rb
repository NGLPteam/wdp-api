# frozen_string_literal: true

module Seeding
  module Export
    # @abstract
    class AbstractEntityExporter < AbstractExporter
      param :input, Seeding::Types::Entity

      def export_collections!(collections)
        dispatch_export! collections.includes(
          :pages, :children, :schema_version, :schema_definition,
          :schematic_texts,
          schematic_collected_references: %i[referent],
          schematic_scalar_references: %i[referent],
        ).to_a
      end

      # @return [Hash]
      def export_properties_from!(entity)
        Seeding::Brokerage.schema_broker_for(entity).extract_properties(entity)
      end
    end
  end
end
