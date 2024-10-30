# frozen_string_literal: true

module Templates
  # @see Layouts::SupplementaryInstance
  # @see Templates::SupplementaryDefinition
  # @see Templates::SlotMappings::SupplementaryInstanceSlots
  # @see Types::Templates::SupplementaryTemplateInstanceType
  class SupplementaryInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :supplementary
    template_kind! :supplementary

    attribute :slots, ::Templates::SlotMappings::SupplementaryInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::SupplementaryTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::SupplementaryInstance",
      inverse_of: :supplementary_template_instances

    belongs_to :template_definition,
      class_name: "Templates::SupplementaryDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
