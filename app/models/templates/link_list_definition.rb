# frozen_string_literal: true

module Templates
  # @see Layouts::MainDefinition
  # @see Templates::LinkListInstance
  # @see Templates::Config::Template::LinkList
  # @see Templates::SlotMappings::LinkListDefinitionSlots
  # @see Types::Templates::LinkListTemplateDefinitionType
  class LinkListDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include Templates::Definitions::HasEntityList
    include Templates::Definitions::HasSeeAllOrdering
    include TimestampScopes

    layout_kind! :main
    template_kind! :link_list

    graphql_node_type_name "::Types::Templates::LinkListTemplateDefinitionType"

    pg_enum! :variant, as: :link_list_variant, allow_blank: false, suffix: :variant

    pg_enum! :background, as: :link_list_background, allow_blank: false, suffix: :background, default: "none"

    pg_enum! :selection_mode, as: :link_list_selection_mode, allow_blank: false, suffix: :selection_mode, default: "manual"

    pg_enum! :selection_fallback_mode, as: :link_list_selection_mode, allow_blank: false, suffix: :selection_fallback_mode, default: "manual"

    pg_enum! :width, as: :template_width, allow_blank: false, suffix: :width, default: "full"

    attribute :dynamic_ordering_definition, ::Schemas::Orderings::Definition.to_type

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
