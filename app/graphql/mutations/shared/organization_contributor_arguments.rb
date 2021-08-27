# frozen_string_literal: true

module Mutations
  module Shared
    module OrganizationContributorArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::ContributorArguments

      included do
        argument :legal_name, String, required: false, description: "The legal name of the organization"
        argument :location, String, required: false, description: "Where the organization is located (if applicable)"
      end
    end
  end
end
