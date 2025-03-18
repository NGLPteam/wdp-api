# frozen_string_literal: true

module Mutations
  module Shared
    # @see Mutations::Extraction::Mapping
    # @see Mutations::Extraction::MappingTemplateValidator
    # @see Mutations::Extraction::ValidateMappingTemplate
    module AcceptsHarvestExtractionMappingTemplate
      extend ActiveSupport::Concern

      included do
        argument :extraction_mapping_template, String, required: true do
          description <<~TEXT
          The extraction mapping template used for this harvesting-related record
          at its place in the hierarchy. It is an XML document that describes how
          to map various types of metadata from the harvested records and transform
          that data into entities in Meru.

          For harvest sources, it can be considered the default mapping template
          for any record in the system, and should be used to pre-populate
          attempts that are created by the source, as well as future plans to
          allow for extracting a single record by external ID that may not have
          yet been fetched by an extract records process.

          For harvest mappings, it can be considered the default mapping template
          for any attempt created by the mapping.

          For any harvesting data that exists prior to the harvesting refactor
          completed during March of 2025, it's possible for this value to be
          an empty string. Any modifications to mappings and sources from that
          time will need to add a valid mapping template in order to succeed.

          See `Query.harvestExamples` for examples of valid mapping templates.
          TEXT
        end
      end
    end
  end
end
