# frozen_string_literal: true

module Layouts
  # @see Layouts::ListItemDefinition
  # @see Types::Layouts::ListItemLayoutInstanceType
  # @see Templates::ListItemInstance
  class ListItemInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::ListItemLayoutInstanceType"

    layout_kind! :list_item
    template_kinds! ["list_item"].freeze

    belongs_to :layout_definition, class_name: "Layouts::ListItemDefinition", inverse_of: :layout_instances

    has_many :list_item_template_instances,
      class_name: "Templates::ListItemInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :template_instance,
      -> { in_recent_order },
      class_name: "Templates::ListItemInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id
  end
end
