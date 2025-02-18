# frozen_string_literal: true

module Seeding
  module Export
    class CollectionExporter < AbstractEntityExporter
      alias collection input

      def export!(json)
        json.merge! collection.slice(:identifier, :title, :subtitle, :doi).transform_values(&:presence).compact

        json.schema collection.schema_definition.declaration

        json.hero_image uploaded_file! collection.hero_image
        json.thumbnail uploaded_file! collection.thumbnail

        json.properties export_properties_from! collection
        json.collections export_collections! collection.children
        json.pages dispatch_export! collection.pages
      end
    end
  end
end
