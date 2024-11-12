# frozen_string_literal: true

module Templates
  module Drops
    class VariablePrecisionDateDrop < Templates::Drops::AbstractDrop
      # @param [VariablePrecisionDate, Date, nil] date
      def initialize(date)
        super()

        @date = ::VariablePrecisionDate.parse(date)
      end

      delegate :value, to: :@date

      def to_liquid
        super unless @date.none?
      end

      def to_s
        call_operation!("templates.mdx.build_variable_precision_date", date: @date)
      end
    end
  end
end
