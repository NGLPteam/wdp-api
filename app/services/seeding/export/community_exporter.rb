# frozen_string_literal: true

module Seeding
  module Export
    class CommunityExporter < AbstractEntityExporter
      alias community input

      def export!(json)
        json.merge! community.slice(:title, :identifier)

        json.schema community.schema_definition.declaration

        json.hero_image uploaded_file! community.hero_image
        json.logo uploaded_file! community.logo
        json.thumbnail uploaded_file! community.thumbnail

        json.properties export_properties_from! community
        json.collections export_collections! community.collections.roots
        json.pages dispatch_export! community.pages
      end
    end
  end
end
