# frozen_string_literal: true

module Types
  class ContributorLinkInputType < Types::BaseInputObject
    description "A mapping to build a contributor link"

    argument :title, String, required: true
    argument :url, String, required: true
  end
end
