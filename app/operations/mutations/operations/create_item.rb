# frozen_string_literal: true

module Mutations
  module Operations
    class CreateItem
      include MutationOperations::Base

      def call(collection:, **args)
        attributes = args.slice(:title, :description)

        item = collection.items.build attributes

        persist_model! item, attach_to: :item
      end
    end
  end
end
