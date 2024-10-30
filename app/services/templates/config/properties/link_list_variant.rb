# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class LinkListVariant < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("link_list_variant").dry_type
      end
    end
  end
end
