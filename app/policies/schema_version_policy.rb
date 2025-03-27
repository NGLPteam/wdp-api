# frozen_string_literal: true

class SchemaVersionPolicy < ApplicationPolicy
  always_readable!

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
