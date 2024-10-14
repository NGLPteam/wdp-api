# frozen_string_literal: true

module Templates
  class LinkListInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :main
    template_kind! :link_list

    attribute :slots, ::Templates::SlotMappings::LinkListInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::LinkListTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::MainInstance",
      inverse_of: :link_list_template_instances

    belongs_to :template_definition,
      class_name: "Templates::LinkListDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
