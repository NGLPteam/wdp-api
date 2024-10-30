# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class NavigationBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("navigation_background").dry_type
      end
    end
  end
end
