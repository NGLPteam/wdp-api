# frozen_string_literal: true

module Mutations
  module Operations
    class CreateAsset
      include MutationOperations::Base

      def call(entity:, attachment:, **args)
        authorize entity, :create_assets?

        attributes = args.compact

        attributes[:attachment] = attachment

        asset = entity.assets.new attributes

        persist_model! asset, attach_to: :asset
      end
    end
  end
end
