# frozen_string_literal: true

module Templates
  class OrderingDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :main
    template_kind! :ordering

    graphql_node_type_name "::Types::Templates::OrderingTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::OrderingDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::MainDefinition",
      inverse_of: :ordering_template_definitions

    has_many :template_instances,
      class_name: "Templates::OrderingInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
