# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ArticleMetaDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        include HasContribGroup

        after_initialize :extract_title_group!

        data_subdrops! AbstractDrop, :abstract, expose_first: true

        data_subdrops! ArticleIdDrop, :article_id

        data_subdrops! KwdGroupDrop, :kwd_group

        data_subdrops! IssueDrop, :issue, expose_first: true

        data_subdrops! IssueIdDrop, :issue_id, expose_first: true

        data_subdrops! SelfUriDrop, :self_uri

        data_subdrops! VolumeDrop, :volume, expose_first: true

        # @return [TitleGroupDrop]
        attr_reader :title_group

        private

        # @return [void]
        def extract_title_group!
          @title_group = subdrop TitleGroupDrop, @data.title_group
        end
      end
    end
  end
end
