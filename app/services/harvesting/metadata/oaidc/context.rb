# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_root!

        after_assigns :build_root_drop!

        # @return [Metadata::OAIDC::Root]
        attr_reader :root

        private

        # @return [void]
        def build_root_drop!
          @assigns[:oaidc] = @root.to_liquid
          @assigns[:journal] = Harvesting::Metadata::OAIDC::JournalDrop.new(@root.find_journal_source)
          @assigns[:doi] = @root.find_doi
          @assigns[:pdf] = Harvesting::Metadata::OAIDC::PDFDrop.new(@root.find_pdf_url)
          @assigns[:creators] = @root.valid_creator_names.map(&:to_liquid)
          @assigns[:contributors] = @root.valid_contributor_names.map(&:to_liquid)
        end

        # @return [void]
        def parse_root!
          @root = ::Metadata::OAIDC::Root.from_xml(metadata_source)
        end
      end
    end
  end
end
