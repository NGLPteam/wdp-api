# frozen_string_literal: true

module Harvesting
  module Metadata
    module Drops
      # Some data has a "content" attribute which should be treated as its string value.
      module HasContent
        extend ActiveSupport::Concern

        included do
          after_initialize :extract_content!
        end

        # @return [String]
        attr_reader :content

        def to_s
          content
        end

        private

        # @abstract
        # @return [String]
        def extract_content
          @data.content
        end

        # @return [String]
        def extract_content!
          @content = extract_content
        end
      end
    end
  end
end
