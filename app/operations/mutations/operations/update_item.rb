# frozen_string_literal: true

module Mutations
  module Operations
    class UpdateItem
      include MutationOperations::Base

      def call(item:, **args)
        authorize item, :update_items?

        attributes = args.compact

        item.assign_attributes attributes

        persist_model! item, attach_to: :item
      end
    end
  end
end
