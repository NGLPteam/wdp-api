# frozen_string_literal: true

module Roles
  class PermissionGrid
    include StoreModel::Model

    attribute :read, :boolean, default: false
    attribute :create, :boolean, default: false
    attribute :update, :boolean, default: false
    attribute :delete, :boolean, default: false
    attribute :manage_access, :boolean, default: false

    # @param [#to_s]
    # @return [Boolean]
    def [](name)
      attributes[name.to_s]
    end

    def calculate_allowed_actions(prefix:)
      attributes.each_with_object([]) do |(action_name, allowed), actions|
        next unless allowed

        name = prefix.present? ? "#{prefix}.#{action_name}" : action_name

        actions << name
      end
    end
  end
end
