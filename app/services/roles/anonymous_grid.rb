# frozen_string_literal: true

module Roles
  # The result of calling {Roles::PermissionGridDefiner}
  class AnonymousGrid < Dry::Struct
    include Dry::Core::Memoizable

    PATTERN = /\A(?:(?<scope>.+)\.)?(?<name>[^.]+)\z/

    attribute :available_actions, Roles::Types::PermissionList
    attribute :allowed_actions, Roles::Types::PermissionList
    attribute :acl, Roles::Types::Hash

    # @!attribute [r] permissions
    # @return [<Permissions::Grant>]
    memoize def permissions
      available_actions.each_with_object([]) do |action, grants|
        name, scope = split_action action

        next if name.blank?

        attrs = { name:, scope: }

        attrs[:allowed] = action.in?(allowed_actions)

        grants << Permissions::Grant.new(attrs)
      end
    end

    private

    # @return [(String, String), (String, nil)]
    def split_action(action)
      match = action.match PATTERN

      return nil if match.blank?

      return [match[:name], match[:scope]]
    end
  end
end
