# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class SelectionSourceMode < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("selection_source_mode").dry_type
      end
    end
  end
end
