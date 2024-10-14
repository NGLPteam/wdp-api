# frozen_string_literal: true

module Templates
  class HeroInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateInstance
    include TimestampScopes

    layout_kind! :hero
    template_kind! :hero

    attribute :slots, ::Templates::SlotMappings::HeroInstanceSlots.to_type

    graphql_node_type_name "::Types::Templates::HeroTemplateInstanceType"

    belongs_to :layout_instance,
      class_name: "Layouts::HeroInstance",
      inverse_of: :hero_template_instances

    belongs_to :template_definition,
      class_name: "Templates::HeroDefinition",
      inverse_of: :template_instances

    belongs_to :entity, polymorphic: true
  end
end
