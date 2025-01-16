# frozen_string_literal: true

module Templates
  module Drops
    # @see SchematicText
    # @see Schemas::Properties::Scalar::FullText
    class FullTextDrop < Templates::Drops::AbstractDrop
      # @return [String]
      attr_reader :content

      # @return [FullText::Types::Kind]
      attr_reader :kind

      # @param [Schemas::PropertyValues::FullText] value
      def initialize(value)
        super()

        @value = Schemas::PropertyValues::FullText.normalize(value)

        @value => { content:, kind:, lang:, }

        @kind = kind
        @lang = lang

        @content = prepare_content(content)
      end

      def to_s
        @content.presence
      end

      private

      def prepare_content(raw_content)
        case kind
        in "markdown"
          call_operation!("full_text.parse_markdown", raw_content)
        else
          raw_content
        end
      end
    end
  end
end
