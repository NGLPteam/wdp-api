# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      module Enum
        extend ActiveSupport::Concern

        module ClassMethods
          # @return [<Object>]
          def actual_values
            values.values.map(&:value)
          end

          # @return [Dry::Types::Type]
          def dry_type
            mapping = values.transform_values do |enum|
              enum.value
            end

            Dry::Types["coercible.string"].constructor do |value|
              mapping.fetch(value, value)
            end.enum(*mapping.values).gql_type(self)
          end

          # @param [String] value
          # @return [Object, nil]
          def name_for_value(value)
            values.each_value.find do |enum|
              enum.value == value
            end&.graphql_name
          end
        end
      end
    end
  end
end
