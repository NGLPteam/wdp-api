# frozen_string_literal: true

module Types
  module ImageIdentificationType
    include Types::BaseInterface

    description <<~TEXT
    An interface for various component types of an image attachment
    that allow it to be identified in name and purpose.
    TEXT

    field :original_filename, String, null: true do
      description <<~TEXT
      The original filename, if one was detected during attachment.

      Filename detection is not always consistent across browsers, so this
      may not always be present, even with a valid attachment.
      TEXT
    end

    field :purpose, Types::ImagePurposeType, null: false do
      description <<~TEXT
      The intended purpose of this image attachment. This is intended to
      help fragments that operate solely on image subcomponents to have
      some context for what they are without extra work.
      TEXT
    end
  end
end
