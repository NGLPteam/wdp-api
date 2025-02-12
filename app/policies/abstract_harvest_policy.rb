# frozen_string_literal: true

# @abstract
class AbstractHarvestPolicy < ApplicationPolicy
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
