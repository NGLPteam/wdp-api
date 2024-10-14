# frozen_string_literal: true

module Templates
  class OrderingInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :main
    template_kind! :ordering

    attribute :slots, ::Templates::SlotMappings::OrderingInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::OrderingTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::MainInstance",
      inverse_of: :ordering_template_instances

    belongs_to :template_definition,
      class_name: "Templates::OrderingDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end