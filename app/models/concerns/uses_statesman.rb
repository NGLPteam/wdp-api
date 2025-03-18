# frozen_string_literal: true

# A helper concern to DRY up state machine wiring in models.
module UsesStatesman
  extend ActiveSupport::Concern

  class_methods do
    # Define a conventions-based state machine.
    #
    # @see Support::StatesmanHelpers::KlassRegistry#build!
    def has_state_machine!(...)
      state_machines.build!(...)
    end

    # @!attribute [r] state_machines
    # @api private
    # @return [Support::StatesmanHelpers::KlassRegistry]
    def state_machines
      @state_machines ||= Support::StatesmanHelpers::KlassRegistry.new(self)
    end
  end
end
