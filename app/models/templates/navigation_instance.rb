# frozen_string_literal: true

module Templates
  class NavigationInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :navigation
    template_kind! :navigation

    attribute :slots, ::Templates::SlotMappings::NavigationInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::NavigationTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::NavigationInstance",
      inverse_of: :navigation_template_instances

    belongs_to :template_definition,
      class_name: "Templates::NavigationDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
