# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class Context < Harvesting::Metadata::XMLContext
        after_initialize :parse_article!

        before_assigns :extract_full_text_data!

        after_assigns :build_article_drop!

        # @return [String, nil]
        attr_reader :abstract

        # @return [Niso::Jats::Article]
        attr_reader :article

        # @return [Boolean]
        attr_reader :article_parsed

        # @return [String, nil]
        attr_reader :body

        private

        # @param [String] raw
        # @return [String]
        def clean_up_metadata_source(raw)
          # Remove the xmlns we manually added with the old harvesting system.
          super.sub(%r,xmlns="https://jats.nlm.nih.gov/publishing/1.2/" ?,, "")
        end

        def extract_full_text_data!
          @abstract = inner_html_for("/article/front/article-meta/abstract")

          @body = inner_html_for("/article/body")
        end

        # @return [void]
        def build_article_drop!
          @assigns[:jats] = build_drop Harvesting::Metadata::JATS::ArticleDrop, @article
        end

        # @return [void]
        def parse_article!
          @article = Niso::Jats::Article.from_xml(metadata_source)
        ensure
          @article_parsed = @article.kind_of?(Niso::Jats::Article)
        end
      end
    end
  end
end
