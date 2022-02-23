# frozen_string_literal: true

module Permissions
  # A single permission granted within a specific scope.
  class Grant < Dry::Struct
    include Dry::Core::Memoizable

    # @!attribute [r] name
    # @return [String]
    attribute :name, Dry::Types["coercible.string"]

    # @!attribute [r] allowed
    # @return [Boolean]
    attribute :allowed, Dry::Types["bool"]

    # @!attribute [r] scope
    # @return [String, nil]
    attribute? :scope, Dry::Types["string"].optional

    # @!attribute [r] allowed_actions
    # @return [<String>]
    memoize def allowed_actions
      allowed ? [path] : []
    end

    # @!attribute [r] path
    # @return [String]
    memoize def path
      [scope, name].compact.join(?.)
    end
  end
end
