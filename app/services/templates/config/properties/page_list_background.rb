# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class PageListBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("page_list_background").dry_type
      end
    end
  end
end
