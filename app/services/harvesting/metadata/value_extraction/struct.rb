# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @abstract
      class Struct < Dry::Struct
        include Shared::Typing
        include Dry::Core::Memoizable

        # A default value for sorting.
        NO_VALUE = (?z * 30).freeze

        map_type! key: Dry::Types["any"]

        schema schema.strict

        transform_keys(&:to_sym)

        transform_types do |type|
          if type.default?
            type.constructor do |value|
              value.nil? ? Dry::Types::Undefined : value
            end
          else
            type
          end
        end

        def no_value
          NO_VALUE
        end

        # @return [Hash]
        def to_full_text_reference(content, kind:, lang: nil)
          FullText::Types::NormalizedReference[content: content, kind: kind, lang: lang]
        end
      end
    end
  end
end
