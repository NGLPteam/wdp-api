# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ArticleMetaDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include HasContribGroup

        data_subdrops! AbstractDrop, :abstract, expose_first: true

        data_subdrops! ArticleIdDrop, :article_id

        data_subdrops! KwdGroupDrop, :kwd_group

        data_subdrops! IssueDrop, :issue, expose_first: true

        data_subdrops! IssueIdDrop, :issue_id, expose_first: true

        data_subdrops! PubDateDrop, :pub_date

        data_subdrops! SelfUriDrop, :self_uri

        data_subdrops! VolumeDrop, :volume, expose_first: true

        after_initialize :extract_doi!

        after_initialize :extract_history!

        after_initialize :extract_published!

        after_initialize :extract_title_group!

        # @return [String, nil]
        attr_reader :doi

        # @return [HistoryDrop]
        attr_reader :history

        # @return [String, nil]
        attr_reader :published

        # @return [TitleGroupDrop]
        attr_reader :title_group

        private

        # @return [void]
        def extract_doi!
          @doi = article_ids.detect(&:doi?)&.to_s
        end

        # @return [void]
        def extract_history!
          @history = subdrop HistoryDrop, @data.history
        end

        # @return [void]
        def extract_published!
          @published = pub_dates.detect(&:pub?)&.to_s
        end

        # @return [void]
        def extract_title_group!
          @title_group = subdrop TitleGroupDrop, @data.title_group
        end
      end
    end
  end
end
