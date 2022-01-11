# frozen_string_literal: true

# @abstract Policies that inherit from this have most of their permissions
#   dictated from the `:update` permission on a parent `entity` association.
class EntityChildRecordPolicy < ApplicationPolicy
  # @return [HierarchicalEntity]
  attr_reader :entity

  # @return [HierarchicalEntityPolicy]
  attr_reader :entity_policy

  # @param [User, AnonymousUser] user
  # @param [#entity] record
  def initialize(user, record)
    super

    @entity = record.entity

    @entity_policy = policy_for @entity
  end

  def show?
    entity_policy.show?
  end

  alias index? show?

  def read?
    entity_policy.read?
  end

  def create?
    entity_policy.update?
  end

  def update?
    entity_policy.update?
  end

  def destroy?
    entity_policy.update?
  end

  def manage_access?
    entity_policy.manage_access?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
