# frozen_string_literal: true

module Types
  # An interface for querying {HarvestExample}.
  module QueriesHarvestExample
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `HarvestExample` records.
    TEXT

    field :harvest_examples, [::Types::HarvestExampleType, { null: false }], null: false do
      description <<~TEXT
      Retrieve harvest examples for the system.
      TEXT

      argument :generic, Boolean, default_value: false, replace_null_with_default: true, required: false do
        description <<~TEXT
        Whether to look for "generic" harvesting examples which are not associated
        with any protocol or metadata.
        TEXT
      end

      argument :protocol, Types::HarvestProtocolType, required: false do
        description <<~TEXT
        The protocol to filter by.
        TEXT
      end

      argument :metadata_format, Types::HarvestMetadataFormatType, required: false do
        description <<~TEXT
        The metadata format to filter by.
        TEXT
      end
    end

    # @param [{ Symbol => Object }]
    # @return [<Harvesting::Example>]
    def harvest_examples(**options)
      ::Harvesting::Example.for_graphql(**options)
    end
  end
end
