# frozen_string_literal: true

module Templates
  module Drops
    class VariablePrecisionDateDrop < Templates::Drops::AbstractDrop
      # @param [VariablePrecisionDate] date
      def initialize(date)
        super()

        @date = date
      end

      delegate :value, to: :@date
    end
  end
end
