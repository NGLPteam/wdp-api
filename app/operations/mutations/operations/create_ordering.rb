# frozen_string_literal: true

module Mutations
  module Operations
    class CreateOrdering
      include MutationOperations::Base

      use_contract! :create_ordering

      def call(entity:, identifier:, **attributes)
        authorize entity, :update?

        ordering = Ordering.by_entity(entity).by_identifier(identifier).new

        ordering.schema_version = entity.schema_version

        ordering.definition ||= {}

        ordering.definition.id = identifier
        ordering.definition.name = attributes[:name]
        ordering.definition.header = attributes[:header]
        ordering.definition.footer = attributes[:footer]
        ordering.definition.select = attributes[:select].as_json.presence || {}
        ordering.definition.filter = attributes[:filter].as_json.presence || {}
        ordering.definition.order = attributes[:order].as_json
        ordering.definition.render = attributes[:render].as_json.presence || {}

        ordering.definition_will_change!

        persist_model! ordering, attach_to: :ordering
      end
    end
  end
end
