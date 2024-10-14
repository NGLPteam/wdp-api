# frozen_string_literal: true

module Templates
  class ListItemDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :list_item
    template_kind! :list_item

    graphql_node_type_name "::Types::Templates::ListItemTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::ListItemDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::ListItemDefinition",
      inverse_of: :list_item_template_definitions

    has_many :template_instances,
      class_name: "Templates::ListItemInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
