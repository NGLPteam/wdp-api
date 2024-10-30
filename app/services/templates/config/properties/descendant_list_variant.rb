# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class DescendantListVariant < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("descendant_list_variant").dry_type
      end
    end
  end
end
