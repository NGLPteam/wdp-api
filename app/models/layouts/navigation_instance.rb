# frozen_string_literal: true

module Layouts
  class NavigationInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::NavigationLayoutInstanceType"

    layout_kind! :navigation
    template_kinds! ["navigation"].freeze

    belongs_to :layout_definition, class_name: "Layouts::NavigationDefinition", inverse_of: :layout_instances

    has_many :navigation_template_instances,
      class_name: "Templates::NavigationInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :template_instance,
      -> { in_recent_order },
      class_name: "Templates::NavigationInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id
  end
end
