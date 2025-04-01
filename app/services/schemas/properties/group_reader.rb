# frozen_string_literal: true

module Schemas
  module Properties
    # A wrapper around a {Schemas::Properties::GroupDefinition group property} that marries it to
    # a {Schemas::Properties::Context value context}. It is consumed by the GraphQL API in order
    # to introspect the properties on a schema instance in a type-safe way.
    #
    # @see Types::Schematic::GroupPropertyType
    class GroupReader < BaseReader
      option :group, Support::GlobalTypes.Instance(Schemas::Properties::GroupDefinition)
      option :context, Support::GlobalTypes.Instance(Schemas::Properties::Context), default: proc { Schemas::Properties::Context.new }
      option :properties, Support::GlobalTypes::Array.of(Support::GlobalTypes.Instance(Schemas::Properties::Reader)), default: proc { [] }

      delegate :legend, :full_path, :path, to: :group
      delegate_missing_to :group

      # @return [Class]
      def graphql_object_type
        ::Types::Schematic::GroupPropertyType
      end

      def required
        group.required?
      end

      # @return [Templates::Drops::GroupPropertyDrop]
      def to_liquid
        Templates::Drops::GroupPropertyDrop.new(self)
      end
    end
  end
end
