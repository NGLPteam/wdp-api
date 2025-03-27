# frozen_string_literal: true

# @see LayoutDefinition
class LayoutDefinitionPolicy < ApplicationPolicy
  always_readable!

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
