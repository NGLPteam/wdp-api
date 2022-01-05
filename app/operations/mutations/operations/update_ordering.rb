# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateOrdering
      include MutationOperations::Base

      def call(ordering:, **attributes)
        authorize ordering.entity, :update?

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
