# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        class AssetKind < ::Mappers::AbstractDryType
          accepts_type! ::Assets::Types::Kind
        end
      end
    end
  end
end
