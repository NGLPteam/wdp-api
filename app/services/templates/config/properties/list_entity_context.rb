# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class ListEntityContext < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("list_entity_context").dry_type
      end
    end
  end
end
