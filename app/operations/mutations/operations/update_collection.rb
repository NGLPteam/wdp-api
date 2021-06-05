# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateCollection
      include MutationOperations::Base

      def call(collection:, **args)
        authorize collection, :update?

        attributes = args.compact

        collection.assign_attributes attributes

        persist_model! collection, attach_to: :collection
      end
    end
  end
end
