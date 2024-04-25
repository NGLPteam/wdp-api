# frozen_string_literal: true

module Support
  module GraphQLAPI
    module ImageAttachmentSupport
      extend ActiveSupport::Concern

      def resolve_image_attachment(graphql_name:)
        attacher = object.public_send :"#{graphql_name.underscore}_attacher"

        ::ImageAttachments::ImageWrapper.new attacher, purpose: graphql_name.underscore
      end

      module ClassMethods
        def image_attachment_field(name, description: nil)
          field name, ::Types::ImageAttachmentType, null: false,
            description:,
            resolver_method: :resolve_image_attachment,
            extras: %i[graphql_name]

          metadata_name = :"#{name}_metadata"

          field metadata_name, ::Types::ImageMetadataType, null: true,
            description: "Configurable metadata for the #{name} attachment"
        end
      end
    end
  end
end
