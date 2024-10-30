# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class HeroBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("hero_background").dry_type
      end
    end
  end
end
