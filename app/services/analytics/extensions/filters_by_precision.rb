# frozen_string_literal: true

module Analytics
  module Extensions
    class FiltersByPrecision < GraphQL::Schema::FieldExtension
      def apply
        field.argument :precision, ::Types::AnalyticsPrecisionType, required: false, default_value: "day" do
          description <<~TEXT
          The precision to apply.
          TEXT
        end
      end
    end
  end
end
