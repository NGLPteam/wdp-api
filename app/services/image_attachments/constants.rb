# frozen_string_literal: true

module ImageAttachments
  # @api private
  module Constants
    extend ActiveSupport::Concern

    # The actual formats we render our variants in.
    FORMATS = %i[webp png].freeze

    # Dimensions that are used for most images in the system.
    #
    # @see ImageAttachments::ImageWrapper
    IMAGE_SIZES = {
      thumb:    [100, 100],
      small:    [250, 250],
      medium:   [500, 500],
      large:    [750, 750],
      hero:     [2880, nil],
    }.freeze

    # Dimensions that are used for site logos.
    #
    # @see ImageAttachments::SiteLogoWrapper
    SITE_LOGO_SIZES = {
      sans_text: [nil, 40],
      with_text: [40, 40],
    }.freeze
  end
end
