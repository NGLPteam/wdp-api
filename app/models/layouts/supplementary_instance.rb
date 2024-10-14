# frozen_string_literal: true

module Layouts
  class SupplementaryInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::SupplementaryLayoutInstanceType"

    layout_kind! :supplementary
    template_kinds! ["supplementary"].freeze

    belongs_to :layout_definition, class_name: "Layouts::SupplementaryDefinition", inverse_of: :layout_instances

    has_many :supplementary_template_instances,
      class_name: "Templates::SupplementaryInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :template_instance,
      -> { in_recent_order },
      class_name: "Templates::SupplementaryInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id
  end
end
