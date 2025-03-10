# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class FrontDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        after_initialize :prepare_drops!

        # @return [Harvesting::Metadata::JATS::ArticleMetaDrop]
        attr_reader :article_meta

        # @return [Harvesting::Metadata::JATS::JournalMetaDrop]
        attr_reader :journal_meta

        private

        # @return [void]
        def prepare_drops!
          @article_meta = subdrop ArticleMetaDrop, @data.article_meta

          @journal_meta = subdrop JournalMetaDrop, @data.journal_meta
        end
      end
    end
  end
end
