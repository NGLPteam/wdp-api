# frozen_string_literal: true

# @see Ordering
class OrderingPolicy < EntityChildRecordPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
