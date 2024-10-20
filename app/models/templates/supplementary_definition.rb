# frozen_string_literal: true

module Templates
  class SupplementaryDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :supplementary
    template_kind! :supplementary

    graphql_node_type_name "::Types::Templates::SupplementaryTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::SupplementaryDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::SupplementaryDefinition",
      inverse_of: :supplementary_template_definitions

    has_many :template_instances,
      class_name: "Templates::SupplementaryInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
