# frozen_string_literal: true

module Types
  # @see Schemas::Versions::CoreDefinition
  class SchemaCoreDefinitionType < Types::BaseObject
    description <<~TEXT
    Configuration for controlling how instances handle specific optional core properties.
    TEXT

    field :doi, Boolean, null: false,
      description: "Whether to expose or hide an entity's DOI"

    field :issn, Boolean, null: false,
      description: "Whether to expose or hide an entity's ISSN"

    field :subtitle, Boolean, null: false,
      description: "Whether to expose or hide an entity's subtitle"
  end
end
