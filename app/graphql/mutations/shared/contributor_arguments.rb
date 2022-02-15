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

        argument :orcid, String, required: false, attribute: true do
          description <<~TEXT
          An optional, unique [**O**pen **R**esearcher and **C**ontributor **ID**](https://orcid.org) associated with this contributor.
          TEXT
        end

        image_attachment! :image
      end
    end
  end
end
