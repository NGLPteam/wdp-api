# frozen_string_literal: true

module Templates
  module Drops
    # @see SchematicText
    # @see Schemas::Properties::Scalar::FullText
    class FullTextReferenceDrop < Templates::Drops::AbstractDrop
      # @return [String]
      attr_reader :content

      # @param [Hash, String, nil] reference
      def initialize(reference)
        super()

        @reference = MeruAPI::Container["full_text.normalizer"].(reference)

        @reference => { content:, kind:, lang:, }

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
