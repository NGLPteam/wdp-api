# frozen_string_literal: true

module Layouts
  # @see Layouts::MainDefinition
  # @see Types::Layouts::MainLayoutInstanceType
  # @see Templates::BlurbInstance
  # @see Templates::DetailInstance
  # @see Templates::DescendantListInstance
  # @see Templates::LinkListInstance
  # @see Templates::PageListInstance
  # @see Templates::ContributorListInstance
  # @see Templates::OrderingInstance
  class MainInstance < ApplicationRecord
    include HasEphemeralSystemSlug
    include LayoutInstance
    include TimestampScopes

    graphql_node_type_name "::Types::Layouts::MainLayoutInstanceType"

    layout_kind! :main
    template_kinds! ["detail", "descendant_list", "link_list", "page_list", "contributor_list", "ordering", "blurb"].freeze

    belongs_to :layout_definition, class_name: "Layouts::MainDefinition", inverse_of: :layout_instances

    has_many :blurb_template_instances,
      class_name: "Templates::BlurbInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :detail_template_instances,
      class_name: "Templates::DetailInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :descendant_list_template_instances,
      class_name: "Templates::DescendantListInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :link_list_template_instances,
      class_name: "Templates::LinkListInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :page_list_template_instances,
      class_name: "Templates::PageListInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :contributor_list_template_instances,
      class_name: "Templates::ContributorListInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_many :ordering_template_instances,
      class_name: "Templates::OrderingInstance",
      dependent: :destroy,
      inverse_of: :layout_instance,
      foreign_key: :layout_instance_id

    has_one :schema_version, through: :layout_definition
  end
end
