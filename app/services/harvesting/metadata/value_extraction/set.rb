# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # A named set of values that can be extracted from a source.
      class Set
        include Dry::Effects::Handler.Resolve
        include Dry::Initializer[undefined: false].define -> do
          param :identifier, Harvesting::Types::Identifier
          param :values, Harvesting::Metadata::ValueExtraction::Value::Map
        end
        include Harvesting::Metadata::ValueExtraction::GeneratesErrors
        include Shared::Typing

        delegate :each_value, to: :values

        map_type! key: Harvesting::Types::Identifier
      end
    end
  end
end
