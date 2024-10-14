# frozen_string_literal: true

module Templates
  class HeroDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :hero
    template_kind! :hero

    graphql_node_type_name "::Types::Templates::HeroTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::HeroDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::HeroDefinition",
      inverse_of: :hero_template_definitions

    has_many :template_instances,
      class_name: "Templates::HeroInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
