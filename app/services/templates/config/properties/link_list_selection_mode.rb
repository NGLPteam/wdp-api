# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class LinkListSelectionMode < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("link_list_selection_mode").dry_type
      end
    end
  end
end
