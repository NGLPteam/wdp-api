# frozen_string_literal: true

module Types
  # @see Types::Layouts::MainDefinitionType
  class AnyMainTemplateDefinitionType < Types::BaseUnion
    description <<~TEXT
    Encompasses all the possible template definition types that can fall under a `MAIN` layout.
    TEXT

    possible_types "Types::Templates::DetailTemplateDefinitionType",
      "Types::Templates::DescendantListTemplateDefinitionType",
      "Types::Templates::LinkListTemplateDefinitionType",
      "Types::Templates::PageListTemplateDefinitionType",
      "Types::Templates::ContributorListTemplateDefinitionType",
      "Types::Templates::OrderingTemplateDefinitionType",
      "Types::Templates::BlurbTemplateDefinitionType"
  end
end
