# frozen_string_literal: true

module Stacks
  module Types
    include Dry.Types

    Callable = Harvesting::Types.Interface(:call)

    MethodName = Symbol

    Evaluable = MethodName | Callable

    Name = Coercible::Symbol

    # @see Stacks::Parent
    Parent = Instance(::Stacks::Parent)
  end
end
