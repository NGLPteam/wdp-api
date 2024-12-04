# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class TemplateWidth < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("template_width").dry_type
      end
    end
  end
end
