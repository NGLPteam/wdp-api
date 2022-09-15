# frozen_string_literal: true

module Analytics
  module Extensions
    class FiltersByDate < GraphQL::Schema::FieldExtension
      def apply
        field.argument :date_filter, ::Types::DateFilterInputType, required: false, default_value: {} do
          description <<~TEXT
          An optional date filter to apply.
          TEXT
        end
      end
    end
  end
end
