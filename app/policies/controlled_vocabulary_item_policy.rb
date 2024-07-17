# frozen_string_literal: true

# @see ControlledVocabularyItem
class ControlledVocabularyItemPolicy < ApplicationPolicy
  def read?
    true
  end

  def destroy?
    false
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
