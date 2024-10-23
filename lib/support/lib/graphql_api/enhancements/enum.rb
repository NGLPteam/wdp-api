# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      module Enum
        extend ActiveSupport::Concern

        included do
          extend Dry::Core::ClassAttributes

          defines :i18n_namespace, type: Support::Types::Coercible::String.optional

          defines :i18n_default_key, type: Support::Types::Coercible::String.optional

          i18n_namespace nil

          i18n_default_key nil
        end

        module ClassMethods
          # @return [<Object>]
          def actual_values
            values.values.map(&:value)
          end

          def define_from_pg_enum!(name)
            pg_enum_values = ApplicationRecord.pg_enum_values(name) rescue []

            type = self

            pg_enum_values.each do |value|
              name = value.to_s.upcase

              self.value(name, value:) do
                description type.i18n_description_for(value)
              end
            end
          end

          def i18n_key
            @i18n_key ||= graphql_name.underscore
          end

          # @return [String, nil]
          def i18n_description_for(value)
            return nil unless i18n_namespace

            base = :"#{i18n_key}.#{value}.description"

            default = [].tap do |defaults|
              defaults << :"default.#{i18n_default_key}.#{value}.description" if description
              defaults << nil
            end

            scope = i18n_namespace.to_sym

            I18n.t(base, scope:, default:, raise: false)
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
