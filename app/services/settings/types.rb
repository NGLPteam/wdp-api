# frozen_string_literal: true

module Settings
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    COLOR_SCHEMES = %w[cream blue].freeze

    FONT_SCHEMES = %w[style1 style2 style3].freeze

    DEFAULT_COLOR_SCHEME = COLOR_SCHEMES.first

    DEFAULT_FONT_SCHEME = FONT_SCHEMES.first

    ColorScheme = string_enum(COLOR_SCHEMES, fallback: DEFAULT_COLOR_SCHEME)

    FontScheme = string_enum(FONT_SCHEMES, fallback: DEFAULT_FONT_SCHEME)
  end
end
