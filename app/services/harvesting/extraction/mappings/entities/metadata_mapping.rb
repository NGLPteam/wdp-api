# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Entities
        # Generates a metadata mapping match value that can selectively put
        # a harvested entity in another part of the tree.
        #
        # @see HarvestMetadataMapping
        class MetadataMapping < Harvesting::Extraction::Mappings::Abstract
          include Dry::Effects::Handler.State(:metadata_mappings)

          attribute :template, ::Mappers::StrippedString

          render_attr! :template, :metadata_mappings_match, data: true do |result|
            result.data["metadata_mappings"]
          end

          xml do
            root "metadata-mapping"

            map_content to: :template
          end

          around_render_template :capture_metadata_mappings!

          def empty?
            template.blank?
          end

          def environment_options
            super.merge(captures_metadata_mappings: true)
          end

          # @see HarvestMetadataMapping.matching
          # @param [Harvesting::Extraction::RenderContext] render_context
          # @return [{ Symbol => <String> }, nil]
          def value_for(render_context)
            rendered_attributes_for(render_context) => { template:, }

            template.value_or(EMPTY_HASH).compact_blank.presence
          end

          private

          # @return [void]
          def capture_metadata_mappings!
            metadata_mappings = Harvesting::Metadata::Types::MetadataMappingsMatch[{}].transform_values(&:dup)

            with_metadata_mappings metadata_mappings do
              yield
            end

            render_data[:metadata_mappings] = metadata_mappings
          end
        end
      end
    end
  end
end
