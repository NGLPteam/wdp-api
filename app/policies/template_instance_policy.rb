# frozen_string_literal: true

class TemplateInstancePolicy < EntityChildRecordPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
