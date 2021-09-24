# frozen_string_literal: true

class EntityLinkPolicy < ApplicationPolicy
  def initialize(user, record)
    super

    @entity = Pundit.policy! self.user, record.source
  end

  attr_reader :entity

  delegate :index?, :show?, :update?, :edit?,
    to: :entity

  def create?
    entity.update?
  end

  def destroy?
    entity.update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
