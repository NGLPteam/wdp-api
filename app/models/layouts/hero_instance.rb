# frozen_string_literal: true

module Layouts
  # @see Layouts::HeroDefinition
  # @see Types::Layouts::HeroLayoutInstanceType
  # @see Templates::HeroInstance
  class HeroInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::HeroLayoutInstanceType"

    layout_kind! :hero
    template_kinds! ["hero"].freeze

    belongs_to :layout_definition, class_name: "Layouts::HeroDefinition", inverse_of: :layout_instances

    has_many :hero_template_instances,
      class_name: "Templates::HeroInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :template_instance,
      -> { in_recent_order },
      class_name: "Templates::HeroInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id
  end
end
