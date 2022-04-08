# frozen_string_literal: true

module Schemas
  module Instances
    class ExtractComposedText
      include WDPAPI::Deps[
        calculate_composed_texts: "entities.calculate_composed_texts"
      ]

      def call(entity)
        calculate_composed_texts.(entity: entity)
      end
    end
  end
end
