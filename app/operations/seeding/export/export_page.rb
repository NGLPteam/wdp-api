# frozen_string_literal: true

module Seeding
  module Export
    # Export a {Page}.
    #
    # @see Seeding::Export::PageExporter
    class ExportPage
      # @param [Page] page
      def call(page)
        Seeding::Export::PageExporter.new(page).call
      end
    end
  end
end
