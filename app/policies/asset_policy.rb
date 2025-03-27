# frozen_string_literal: true

class AssetPolicy < EntityChildRecordPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
