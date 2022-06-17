# frozen_string_literal: true

module Types
  # @see ImageAttachments::Size
  class ImageDerivativeSizeType < Types::BaseEnum
    description "The size of a specific image derivative."

    ImageAttachments.each_size do |size|
      value size.graphql_enum_name, value: size.name do
        description size.graphql_description
      end
    end
  end
end
