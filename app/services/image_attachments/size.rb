# frozen_string_literal: true

module ImageAttachments
  # @api private
  class Size < Dry::Struct
    attribute :name, ImageAttachments::Types::Size
    attribute :width, ImageAttachments::Types::Dimension
    attribute :height, ImageAttachments::Types::Dimension

    # @return [(Integer, Integer)]
    def dimensions
      [width, height]
    end
  end
end
