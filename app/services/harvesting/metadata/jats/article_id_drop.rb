# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ArticleIdDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include Harvesting::Metadata::Drops::HasContent

        data_attr! :pub_id_type, :string

        after_initialize :extract_doi!

        # @return [Boolean]
        attr_reader :doi

        alias doi? doi

        private

        # @return [void]
        def extract_doi!
          @doi = pub_id_type == "doi"
        end
      end
    end
  end
end
