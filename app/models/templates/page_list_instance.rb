# frozen_string_literal: true

module Templates
  class PageListInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :main
    template_kind! :page_list

    attribute :slots, ::Templates::SlotMappings::PageListInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::PageListTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::MainInstance",
      inverse_of: :page_list_template_instances

    belongs_to :template_definition,
      class_name: "Templates::PageListDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
