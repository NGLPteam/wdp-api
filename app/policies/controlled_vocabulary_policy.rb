# frozen_string_literal: true

# @see ControlledVocabulary
class ControlledVocabularyPolicy < ApplicationPolicy
  def read?
    true
  end

  def upsert?
    user.has_global_admin_access?
  end

  alias create? upsert?
  alias update? upsert?

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
