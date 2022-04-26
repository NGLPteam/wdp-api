# frozen_string_literal: true

module Seeding
  module Export
    class RootExporter < AbstractExporter
      option :communities, Seeding::Types::IdentifierList.constrained(min_size: 1)

      def export!(json)
        json.version "1.0.0"

        json.communities dispatch_export!(Community.by_identifier(communities))
      end
    end
  end
end
