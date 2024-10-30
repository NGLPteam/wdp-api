# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class DetailBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("detail_background").dry_type
      end
    end
  end
end
