# frozen_string_literal: true

module Mutations
  module Contracts
    class PersonContributor < ApplicationContract
      json ::Contributors::SharedSchema do
        required(:given_name).filled("coercible.string")
        required(:family_name).filled("coercible.string")
        optional(:title).maybe(:string)
        optional(:affiliation).maybe(:string)
      end

      include ::Contributors::SharedRules
    end
  end
end
