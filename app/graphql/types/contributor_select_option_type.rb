# frozen_string_literal: true

module Types
  class ContributorSelectOptionType < Types::BaseObject
    description "A select option for a single contributor"

    field :label, String, null: false
    field :value, String, null: false
    field :kind, Types::ContributorKindType, null: false
  end
end
