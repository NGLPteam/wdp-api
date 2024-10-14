# frozen_string_literal: true

module Templates
  class NavigationDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :navigation
    template_kind! :navigation

    graphql_node_type_name "::Types::Templates::NavigationTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::NavigationDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::NavigationDefinition",
      inverse_of: :navigation_template_definitions

    has_many :template_instances,
      class_name: "Templates::NavigationInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
