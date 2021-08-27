# frozen_string_literal: true

module Mutations
  module Shared
    module PersonContributorArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::ContributorArguments

      included do
        argument :given_name, String, required: false
        argument :family_name, String, required: false
        argument :title, String, required: false
        argument :affiliation, String, required: false
      end
    end
  end
end
