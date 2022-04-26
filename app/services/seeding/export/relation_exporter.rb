# frozen_string_literal: true

module Seeding
  module Export
    class RelationExporter < AbstractObjectExporter
      alias relation input

      def export!(json)
        content = relation.map do |model|
          dispatch_export!(model)&.attributes!
        end.compact

        return json.null! if content.blank?

        json.array! content
      end
    end
  end
end
