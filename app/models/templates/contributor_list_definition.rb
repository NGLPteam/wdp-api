# frozen_string_literal: true

module Templates
  class ContributorListDefinition < ApplicationRecord
    include HasEphemeralSystemSlug
    include TemplateDefinition
    include TimestampScopes

    layout_kind! :main
    template_kind! :contributor_list

    graphql_node_type_name "::Types::Templates::ContributorListTemplateDefinitionType"
    pg_enum! :background, as: :contributor_list_background, allow_blank: false, suffix: :background, default: "none"

    attribute :slots, ::Templates::SlotMappings::ContributorListDefinitionSlots.to_type

    belongs_to :layout_definition,
      class_name: "Layouts::MainDefinition",
      inverse_of: :contributor_list_template_definitions

    has_many :template_instances,
      class_name: "Templates::ContributorListInstance",
      dependent: :destroy,
      inverse_of: :template_definition,
      foreign_key: :template_definition_id
  end
end
