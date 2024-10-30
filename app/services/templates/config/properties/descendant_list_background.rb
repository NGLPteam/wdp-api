# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class DescendantListBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("descendant_list_background").dry_type
      end
    end
  end
end
