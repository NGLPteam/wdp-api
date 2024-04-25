# frozen_string_literal: true

module Support
  module Authorization
    # An error raised when feeding an invalid condition
    # to the identity processor. This indicates a logic
    # error or a typo somewhere in the code.
    class InvalidCondition < StandardError
      attr_reader :condition

      def initialize(condition, *extra)
        @condition = condition

        super("Cannot process #{condition.inspect}", *extra)
      end
    end
  end
end
