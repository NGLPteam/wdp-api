# frozen_string_literal: true

module Mutations
  module Operations
    class CreateCollection
      include MutationOperations::Base

      def call(**args)
        attributes = args.slice(:title, :description)

        collection = Collection.new attributes

        persist_model! collection, attach_to: :collection
      end
    end
  end
end
