# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::BuildVariablePrecisionDate
    class VariablePrecisionDateBuilder < ::Templates::MDX::AbstractBuilder
      tag_name "VariablePrecisionDate"

      option :date, Types.Instance(::VariablePrecisionDate)

      delegate :precision, :value, to: :date

      def build_attributes
        precision = ::Types::DatePrecisionType.name_for_value self.precision
        value = self.value.to_s

        super.merge(precision:, value:)
      end

      def build_inner_html
        case precision
        in :year
          value.strftime("%Y")
        in :month
          value.strftime("%Y-%m")
        in :day
          value.strftime("%Y-%m-%d")
        else
          "n/a"
        end
      end
    end
  end
end
