# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class TitleGroupDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        after_initialize :extract_drops!

        # @return [ArticleTitleDrop]
        attr_reader :article_title

        # @return [SubtitleDrop]
        attr_reader :subtitle

        data_subdrops! SubtitleDrop, :subtitle, expose_first: true

        private

        # @return [void]
        def extract_drops!
          @article_title = subdrop ArticleTitleDrop, @data.article_title
        end
      end
    end
  end
end
