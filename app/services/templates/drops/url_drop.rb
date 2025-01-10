# frozen_string_literal: true

module Templates
  module Drops
    # @see Schemas::Properties::Scalar::URL
    # @see Schemas::Properties::Types::NormalizedURL
    # @see Schemas::Properties::Types::URLShape
    # @see Schemas::PropertyValues::URL
    class URLDrop < Templates::Drops::AbstractDrop
      delegate :href, :label, :title, allow_nil: true, to: :@url

      # @return [String, nil]
      attr_reader :anchor_tag

      # @param [Schemas::PropertyValues::URL] url
      def initialize(url)
        super()

        @url = Schemas::PropertyValues::URL.normalize(url)

        @anchor_tag = @url.try(:anchor_tag)
      end

      def to_s
        anchor_tag.to_s
      end
    end
  end
end
