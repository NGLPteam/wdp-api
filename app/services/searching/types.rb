# frozen_string_literal: true

module Searching
  # Types module for searching subsystem.
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    # @api private
    OPERATOR_NAMES = %w[
      equals
      matches
      in_any
      date_gte
      date_lte
      numeric_gte
      numeric_lte
    ].freeze

    EntityOrigin = Instance(::HierarchicalEntity)

    GlobalOrigin = Value(:global)

    JoinEncoder = Interface(:call)

    SchemaOrigin = Instance(::SchemaVersion)

    OperatorName = String.enum(*OPERATOR_NAMES)

    OriginModel = GlobalOrigin | EntityOrigin | SchemaOrigin

    OriginType = Symbol.enum(:entity, :global, :schema).constructor do |value|
      case value
      when EntityOrigin then :entity
      when SchemaOrigin then :schema
      else
        value
      end
    end

    # A type that automatically builds an origin.
    #
    # @see Searching::Origin
    Origin = Instance(::Searching::Origin).constructor do |value|
      case value
      when OriginModel then ::Searching::Origin.new(value)
      else
        value
      end
    end
  end
end
