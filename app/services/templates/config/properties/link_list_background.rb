# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class LinkListBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("link_list_background").dry_type
      end
    end
  end
end
