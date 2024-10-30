# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class DescendantListSelectionMode < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("descendant_list_selection_mode").dry_type
      end
    end
  end
end
