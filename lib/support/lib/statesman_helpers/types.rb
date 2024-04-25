# frozen_string_literal: true

module Support
  module StatesmanHelpers
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      AssociationName = Coercible::Symbol

      MachineClass = Implements(::Statesman::Machine)

      Predicates = Value(:ALL) | Array.of(Coercible::Symbol)

      TransitionClass = Inherits(::ActiveRecord::Base)
    end
  end
end
