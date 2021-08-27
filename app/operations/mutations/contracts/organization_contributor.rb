# frozen_string_literal: true

module Mutations
  module Contracts
    class OrganizationContributor < ApplicationContract
      json ::Contributors::SharedSchema do
        required(:legal_name).filled("coercible.string")
        optional(:location).maybe(:string)
      end

      include ::Contributors::SharedRules
    end
  end
end
