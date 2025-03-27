# frozen_string_literal: true

module Templates
  # @see Templates::InstanceDigest
  class InstanceDigestPolicy < ApplicationPolicy
    always_readable!

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
