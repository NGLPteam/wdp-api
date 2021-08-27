# frozen_string_literal: true

module Mutations
  module Shared
    module ContributorArguments
      extend ActiveSupport::Concern

      included do
        argument :email, String, required: false, description: "An email associated with the contributor", attribute: true
        argument :url, String, required: false, description: "A url associated with the contributor", attribute: true
        argument :bio, String, required: false, description: "A summary of the contributor", attribute: true

        argument :links, [Types::ContributorLinkInputType], required: false, attribute: true

        argument :image, Types::UploadedFileInputType, required: false, attribute: true do
          description <<~TEXT.strip_heredoc
          A reference to an upload in Tus.
          TEXT
        end
      end
    end
  end
end