# frozen_string_literal: true

class EntityLinkPolicy < ApplicationPolicy
  def initialize(user, record)
    super

    @source_policy = policy_for record.source
  end

  # @return [HierarchicalChildPolicy]
  attr_reader :source_policy

  delegate :read?, :index?, :show?, :update?, to: :source_policy

  def create?
    source_policy.update?
  end

  def destroy?
    source_policy.update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
