# frozen_string_literal: true

module Analytics
  module Extensions
    class FiltersByUnitedStatesOnly < GraphQL::Schema::FieldExtension
      # @return [void]
      def apply
        field.argument :us_only, GraphQL::Types::Boolean, required: false, default_value: false do
          description <<~TEXT
          Filter by country_code = "US" only.
          TEXT
        end
      end
    end
  end
end
