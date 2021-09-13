# frozen_string_literal: true

module Mutations
  module Shared
    module EntityArguments
      extend ActiveSupport::Concern

      included do
        argument :title, String, required: true, description: "Human readable title for the entity", attribute: true

        argument :thumbnail, Types::UploadedFileInputType, required: false, attribute: true do
          description <<~TEXT.strip_heredoc
          A reference to an uploaded image in Tus.
          TEXT
        end
      end
    end
  end
end
