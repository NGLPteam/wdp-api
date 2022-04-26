# frozen_string_literal: true

module Seeding
  module Export
    class PageExporter < AbstractObjectExporter
      alias page input

      def export!(json)
        json.slug page.slug
        json.title page.title
        json.body page.body
      end
    end
  end
end
