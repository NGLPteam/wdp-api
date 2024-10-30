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

      include Templates::Instances::HasSelectionSource

      # @return [Templates::EntityList]
      def entity_list
        fetch_entity_list!
      end

      monadic_operation! def fetch_entity_list
        call_operation("templates.instances.fetch_entity_list", self)
      end
    end
  end
end
