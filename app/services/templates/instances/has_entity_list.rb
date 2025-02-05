# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::EntityList
    # @see Templates::Instances::FetchEntityList
    # @see Templates::Instances::EntityListFetcher
    # @see Templates::Definitions::HasEntityList
    # @see Types::TemplateEntityListType
    # @see Types::TemplateHasEntityListType
    module HasEntityList
      extend ActiveSupport::Concern
      extend DefinesMonadicOperation

      include ::TemplateInstance
      include Templates::Instances::HasSelectionSource

      included do
        after_save :clear_entity_list!
      end

      # @return [Templates::EntityList]
      def entity_list
        @entity_list ||= fetch_entity_list!
      end

      monadic_operation! def fetch_entity_list
        call_operation("templates.instances.fetch_entity_list", self)
      end

      def hidden?
        super || hidden_by_entity_list?
      end

      # @!attribute [r] hidden_by_entity_list
      # @return [Boolean]
      def hidden_by_entity_list
        !list_item_template? && entity_list.empty?
      end

      alias hidden_by_entity_list? hidden_by_entity_list

      private

      # @return [void]
      def clear_entity_list!
        @entity_list = nil
      end
    end
  end
end
