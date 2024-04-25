# frozen_string_literal: true

module Mutations
  module Operations
    class LinkEntity
      include MutationOperations::Base
      include MeruAPI::Deps[connect: "links.connect"]

      def call(source:, target:, operator:)
        authorize source, :update?
        authorize target, :read?

        result = connect.call(source, target, operator)

        with_attached_result! :link, result
      end
    end
  end
end
