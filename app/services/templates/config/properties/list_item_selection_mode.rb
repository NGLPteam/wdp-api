# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class ListItemSelectionMode < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("list_item_selection_mode").dry_type
      end
    end
  end
end
