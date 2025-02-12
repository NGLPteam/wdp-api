# frozen_string_literal: true

# @see HarvestMapping
class HarvestMappingPolicy < AbstractHarvestPolicy
  def create?
    has_admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
