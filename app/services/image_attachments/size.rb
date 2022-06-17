# frozen_string_literal: true

module ImageAttachments
  # @api private
  class Size < Dry::Struct
    include Dry::Core::Memoizable

    attribute :name, ImageAttachments::Types::Size
    attribute :width, ImageAttachments::Types::Dimension.optional
    attribute :height, ImageAttachments::Types::Dimension.optional

    # @return [(Integer, Integer)]
    # @return [(Integer, nil)]
    # @return [(nil, Integer)]
    memoize def dimensions
      [width, height].freeze
    end

    # @!attribute [r] graphql_description
    # @return [String]
    memoize def graphql_description
      [graphql_prefix, graphql_suffix, ?.].compact.join
    end

    # @!attribute [r] graphql_enum_name
    # @return [String]
    memoize def graphql_enum_name
      name.to_s.upcase
    end

    memoize def human_readable_dimensions
      if width.present? && height.present?
        "%dpx wide by %dpx high" % dimensions
      elsif width.present?
        "%dpx wide with no height limit" % width
      elsif height.present?
        "%dpx high with no width limit" % height
      end
    end

    private

    def graphql_prefix
      case name
      when :sans_text
        "A logo intended to be used when the site title is hidden"
      when :with_text
        "A logo intended to be used when the site title is visible"
      else
        "A #{name}-sized image"
      end
    end

    def graphql_suffix
      ", constrained to #{human_readable_dimensions}" if human_readable_dimensions.present?
    end
  end
end
