# frozen_string_literal: true

module Layouts
  class HeroDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutDefinition
    include TimestampScopes

    layout_kind! :hero
    template_kinds! ["hero"].freeze

    graphql_node_type_name "::Types::Layouts::HeroLayoutDefinitionType"

    belongs_to :schema_version, inverse_of: :hero_layout_definitions
    belongs_to :entity, polymorphic: true, optional: true

    has_many :layout_instances,
      class_name: "Layouts::HeroInstance",
      dependent: :destroy,
      inverse_of: :layout_definition,
      foreign_key: :layout_definition_id

    has_many :hero_template_definitions,
      class_name: "Templates::HeroDefinition",
      dependent: :destroy,
      inverse_of: :layout_definition,
      foreign_key: :layout_definition_id

    has_one :template_definition,
      -> { in_recent_order },
      class_name: "Templates::HeroDefinition",
      dependent: :destroy,
      inverse_of: :layout_definition,
      foreign_key: :layout_definition_id
  end
end
