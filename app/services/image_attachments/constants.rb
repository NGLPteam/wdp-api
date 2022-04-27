# frozen_string_literal: true

module ImageAttachments
  # @api private
  module Constants
    extend ActiveSupport::Concern

    FORMATS = %i[webp png].freeze

    SIZES = {
      thumb:    [100, 100],
      small:    [250, 250],
      medium:   [500, 500],
      large:    [750, 750],
      hero:     [2880, nil],
    }.freeze
  end
end
