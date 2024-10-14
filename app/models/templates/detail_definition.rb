# frozen_string_literal: true

module Templates
  class DetailDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :main
    template_kind! :detail

    graphql_node_type_name "::Types::Templates::DetailTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::DetailDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::MainDefinition",
      inverse_of: :detail_template_definitions

    has_many :template_instances,
      class_name: "Templates::DetailInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
