# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class BlurbBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("blurb_background").dry_type
      end
    end
  end
end
