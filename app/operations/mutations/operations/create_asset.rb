# frozen_string_literal: true

module Mutations
  module Operations
    class CreateAsset
      include MutationOperations::Base

      def call(entity:, attachment_url:, mime_type:, filename: File.basename(attachment_url), **args)
        authorize entity, :create_assets?

        attributes = args.compact

        id = File.basename(attachment_url)

        attributes[:attachment] = {
          id: id,
          storage: :cache,
          metadata: {
            filename: filename,
            mime_type: mime_type
          }
        }

        asset = entity.assets.new attributes

        persist_model! asset, attach_to: :asset
      end
    end
  end
end
