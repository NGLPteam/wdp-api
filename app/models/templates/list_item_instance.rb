# frozen_string_literal: true

module Templates
  class ListItemInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :list_item
    template_kind! :list_item

    attribute :slots, ::Templates::SlotMappings::ListItemInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::ListItemTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::ListItemInstance",
      inverse_of: :list_item_template_instances

    belongs_to :template_definition,
      class_name: "Templates::ListItemDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
