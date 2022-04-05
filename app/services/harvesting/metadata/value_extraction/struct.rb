# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      # @abstract
      class Struct < Dry::Struct
        include ActiveModel::Validations
        include Shared::Typing
        include Dry::Core::Memoizable
        include Dry::Monads[:result]

        VARIABLE_DATE_SERIALIZATION = {
          year: "(%04d-01-01,year)",
          month: "(%04d-%02d-01,month)",
          day: "(%04d-%02d-%02d,day)",
          none: "(,none)",
        }.freeze

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

        # @param [#to_s] year
        # @param [#to_s] month
        # @param [#to_s] day
        # @return [VariablePrecisionDate]
        def to_variable_precision_date(year, month, day)
          precision = variable_date_precision_for year, month, day

          format = VARIABLE_DATE_SERIALIZATION.fetch precision

          VariablePrecisionDate.parse format % [year, month, day]
        rescue ArgumentError
          # :nocov:
          VariablePrecisionDate.none
          # :nocov:
        end

        def variable_date_precision_for(year, month, day)
          if month.present? && day.present?
            :day
          elsif month.present?
            :month
          elsif year.present?
            :year
          else
            # :nocov:
            :none
            # :nocov:
          end
        end
      end
    end
  end
end
