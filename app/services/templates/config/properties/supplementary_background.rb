# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class SupplementaryBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("supplementary_background").dry_type
      end
    end
  end
end
