# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ArticleDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        after_initialize :prepare_drops!

        after_initialize :extract_journal_drops!

        after_initialize :extract_titles!

        data_attrs! :article_type, :lang, type: :string

        # @return [Harvesting::Metadata::JATS::AbstractDrop]
        attr_reader :abstract

        # @return [Harvesting::Metadata::JATS::ArticleTitleDrop]
        attr_reader :article_title

        # @return [Harvesting::Metadata::JATS::BodyDrop]
        attr_reader :body

        # @return [Harvesting::Metadata::JATS::FrontDrop]
        attr_reader :front

        # @return [Harvesting::Metadata::JATS::IssueDrop]
        attr_reader :issue

        # @return [Harvesting::Metadata::JATS::IssueIdDrop]
        attr_reader :issue_id

        # @return [Harvesting::Metadata::JATS::SubtitleDrop]
        attr_reader :subtitle

        # @return [Harvesting::Metadata::JATS::VolumeDrop]
        attr_reader :volume

        private

        # @return [void]
        def prepare_drops!
          @body = subdrop BodyDrop, @article.body

          @front = subdrop FrontDrop, @article.front

          @article_meta = @front.try(:article_meta)
        end

        # @return [void]
        def extract_journal_drops!
          @issue = @article_meta.try(:issue)

          @issue_id = @article_meta.try(:issue_id)

          @volume = @article_meta.try(:volume)
        end

        # @return [void]
        def extract_titles!
          title_group = @article_meta.try(:title_group)

          @article_title = title_group.try(:article_title)

          @subtitle = title_group.try(:subtitle)
        end
      end
    end
  end
end
