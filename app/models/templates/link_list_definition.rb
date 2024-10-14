# frozen_string_literal: true

module Templates
  class LinkListDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :main
    template_kind! :link_list

    graphql_node_type_name "::Types::Templates::LinkListTemplateDefinitionType"

    attribute :slots, ::Templates::SlotMappings::LinkListDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::MainDefinition",
      inverse_of: :link_list_template_definitions

    has_many :template_instances,
      class_name: "Templates::LinkListInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
