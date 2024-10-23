# frozen_string_literal: true

module Templates
  class DescendantListDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :main
    template_kind! :descendant_list

    graphql_node_type_name "::Types::Templates::DescendantListTemplateDefinitionType"
    pg_enum! :variant, as: :descendant_list_variant, allow_blank: false, suffix: :variant

    pg_enum! :background, as: :descendant_list_background, allow_blank: false, suffix: :background, default: "none"

    pg_enum! :selection_source_mode, as: :selection_source_mode, allow_blank: false, suffix: :selection_source_mode, default: "self"

    pg_enum! :selection_mode, as: :descendant_list_selection_mode, allow_blank: false, suffix: :selection_mode, default: "manual"

    attribute :dynamic_ordering_definition, ::Schemas::Orderings::Definition.to_type

    attribute :slots, ::Templates::SlotMappings::DescendantListDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::MainDefinition",
      inverse_of: :descendant_list_template_definitions

    has_many :template_instances,
      class_name: "Templates::DescendantListInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
