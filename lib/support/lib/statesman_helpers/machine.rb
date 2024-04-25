# frozen_string_literal: true

module Support
  module StatesmanHelpers
    module Machine
      extend ActiveSupport::Concern

      include Statesman::Machine

      module ClassMethods
        # Define transitions that allow any state to transition into any other state
        # @return [void]
        def flexible_transitions!
          states.each do |from|
            to = states.without(from)

            transition(from:, to:)
          end
        end
      end
    end
  end
end
