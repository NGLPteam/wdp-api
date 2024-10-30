# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class OrderingBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("ordering_background").dry_type
      end
    end
  end
end
