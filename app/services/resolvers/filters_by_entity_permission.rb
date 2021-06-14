# frozen_string_literal: true

module Resolvers
  module FiltersByEntityPermission
    extend ActiveSupport::Concern

    included do
      option :access, type: Types::EntityPermissionFilterType, default: "READ_ONLY"
    end

    def apply_access_with_read_only(scope)
      scope.with_permitted_actions_for(object, "self.read")
    end

    def apply_access_with_crud(scope)
      scope.with_permitted_actions_for(object, "self.read", "self.create", "self.update", "self.delete")
    end
  end
end
