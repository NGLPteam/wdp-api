# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module DSL
        module BuildsValues
          extend ActiveSupport::Concern

          def initialize(...)
            super

            @values = {}
          end

          def has_value?(id)
            id = Harvesting::Types::Identifier[id]

            @values.key? id
          end

          # @!group DSL Methods

          def attribute(id, *attribute_names, **options, &)
            value id, **options do
              attribute(*attribute_names, **options, &)
            end
          end

          def xpath(id, *queries, **options, &)
            value id, **options do
              xpath(*queries, **options, &)
            end
          end

          def xpath_list(id, *queries, **options, &)
            value id, **options do
              xpath_list(*queries, **options, &)
            end
          end

          def value(id, **options, &)
            value = DSL::ValueBuilder.new(id, **options).build(&)

            raise "existing value" if @values[value.identifier].present?

            @values[value.identifier] = value
          end

          def compose_value(id, from:, **options, &block)
            value id, **options do
              from_value(from, **options, &block)
            end
          end

          # @!endgroup
        end
      end
    end
  end
end
