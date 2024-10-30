# frozen_string_literal: true

module Templates
  module Config
    module Properties
      class MetadataBackground < ::Mappers::AbstractDryType
        accepts_type! TemplateEnumProperty.find("metadata_background").dry_type
      end
    end
  end
end
