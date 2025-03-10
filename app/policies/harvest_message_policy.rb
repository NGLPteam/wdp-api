# frozen_string_literal: true

# @see HarvestMessage
class HarvestMessagePolicy < AbstractHarvestPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
