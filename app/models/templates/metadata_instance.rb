# frozen_string_literal: true

module Templates
  class MetadataInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :metadata
    template_kind! :metadata

    attribute :slots, ::Templates::SlotMappings::MetadataInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::MetadataTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::MetadataInstance",
      inverse_of: :metadata_template_instances

    belongs_to :template_definition,
      class_name: "Templates::MetadataDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
