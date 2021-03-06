# frozen_string_literal: true

module Roles
  class PermissionGrid
    include Roles::Grid

    permission :read, :create, :update, :delete
  end
end
