# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class DetailVariant < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("detail_variant").dry_type
      end
    end
  end
end
