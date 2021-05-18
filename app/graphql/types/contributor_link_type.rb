# frozen_string_literal: true

module Types
  class ContributorLinkType < Types::BaseObject
    description "A link for a contributor"

    field :title, String, null: false
    field :url, String, null: false
  end
end
