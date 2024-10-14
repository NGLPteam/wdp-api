# frozen_string_literal: true

module Layouts
  class MetadataInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::MetadataLayoutInstanceType"

    layout_kind! :metadata
    template_kinds! ["metadata"].freeze

    belongs_to :layout_definition, class_name: "Layouts::MetadataDefinition", inverse_of: :layout_instances

    has_many :metadata_template_instances,
      class_name: "Templates::MetadataInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :template_instance,
      -> { in_recent_order },
      class_name: "Templates::MetadataInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id
  end
end
