# frozen_string_literal: true

module Types
  # An interface that exposes {Types::EffectiveAccessType}.
  module ExposesEffectiveAccessType
    include Types::BaseInterface

    field :effective_access, Types::EffectiveAccessType, null: false do
      description <<~TEXT
      User-specific access permissions for this object.
      TEXT
    end

    # @see ApplicationPolicy#effective_access
    # @return [Roles::AnonymousGrid]
    def effective_access
      policy(object).effective_access
    end
  end
end
