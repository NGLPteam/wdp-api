# frozen_string_literal: true

# @abstract
class AbstractHarvestPolicy < ApplicationPolicy
  readable_in_dev true

  def prune_entities?
    has_admin?
  end

  class Scope < Scope
    def resolve
      if has_global_admin_access? || Rails.env.development?
        scope.all
      else
        scope.none
      end
    end
  end
end
