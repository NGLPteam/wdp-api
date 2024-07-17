# frozen_string_literal: true

# @see ControlledVocabularySource
class ControlledVocabularySourcePolicy < ApplicationPolicy
  def read?
    true
  end

  def create?
    false
  end

  def update?
    user.has_global_admin_access?
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
