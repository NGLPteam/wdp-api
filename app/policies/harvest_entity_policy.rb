# frozen_string_literal: true

# @see HarvestEntity
class HarvestEntityPolicy < AbstractHarvestPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
