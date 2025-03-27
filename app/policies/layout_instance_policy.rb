# frozen_string_literal: true

class LayoutInstancePolicy < EntityChildRecordPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
