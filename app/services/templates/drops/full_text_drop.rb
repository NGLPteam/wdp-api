# frozen_string_literal: true

module Templates
  module Drops
    # @see SchematicText
    # @see Schemas::Properties::Scalar::FullText
    class FullTextDrop < Templates::Drops::AbstractDrop
      # @return [String]
      attr_reader :content

      # @param [Schemas::PropertyValues::FullText] value
      def initialize(value)
        super()

        @value = Schemas::PropertyValues::FullText.normalize(value)

        @value => { content:, kind:, lang:, }

        @content = content
        @kind = kind
        @lang = lang
      end

      def to_s
        @content.presence
      end
    end
  end
end
