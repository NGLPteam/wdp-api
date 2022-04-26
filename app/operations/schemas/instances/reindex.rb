# frozen_string_literal: true

module Schemas
  module Instances
    class Reindex
      include Dry::Monads[:result, :do]
      include WDPAPI::Deps[
        extract_core_texts: "schemas.instances.write_core_texts",
        extract_searchable_properties: "schemas.instances.extract_searchable_properties",
        extract_composed_text: "schemas.instances.extract_composed_text",
      ]

      # @param [HierarchicalEntity] entity
      def call(entity)
        yield extract_core_texts.(entity)

        yield extract_searchable_properties.(entity)

        yield extract_composed_text.(entity)

        Success()
      end
    end
  end
end
