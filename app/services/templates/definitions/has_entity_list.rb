# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::EntityList
    # @see Templates::Instances::FetchEntityList
    # @see Templates::Instances::EntityListFetcher
    # @see Templates::Instances::HasEntityList
    # @see Types::TemplateEntityListType
    # @see Types::TemplateHasEntityListType
    module HasEntityList
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation

      include Templates::Definitions::HasSelectionSource

      included do
        has_one :manual_list,
          class_name: "Templates::ManualList",
          as: :template_definition,
          dependent: :destroy

        after_save :maintain_manual_list!
      end

      monadic_operation! def maintain_manual_list
        call_operation("templates.definitions.maintain_manual_list", self)
      end

      def to_entity_list_resolution(fallback: false, source_entity: nil)
        {
          selection_mode: fallback ? selection_fallback_mode : selection_mode,
          selection_limit:,
          source_entity:,
          template_definition_id: id,
          template_kind:,
          layout_kind:,
          fallback:,
        }.tap do |opt|
          case opt[:selection_mode]
          in "dynamic"
            opt.merge!(dynamic_ordering_definition:)
          in "manual"
            opt.merge!(manual_list_name:)
          in "named"
            opt.merge!(ordering_identifier:)
          in "property"
            opt.merge!(selection_property_path:)
          end
        end
      end
    end
  end
end
