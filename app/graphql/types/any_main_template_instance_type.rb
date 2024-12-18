# frozen_string_literal: true

module Types
  # @see Types::Layouts::MainInstanceType
  class AnyMainTemplateInstanceType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template instance types that can fall under a `MAIN` layout.
    TEXT

    possible_types "Types::Templates::DetailTemplateInstanceType",
      "Types::Templates::DescendantListTemplateInstanceType",
      "Types::Templates::LinkListTemplateInstanceType",
      "Types::Templates::PageListTemplateInstanceType",
      "Types::Templates::ContributorListTemplateInstanceType",
      "Types::Templates::OrderingTemplateInstanceType",
      "Types::Templates::BlurbTemplateInstanceType"
  end
end
