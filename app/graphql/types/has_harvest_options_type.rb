# frozen_string_literal: true

module Types
  # @see HasHarvestingOptions
  module HasHarvestOptionsType
    include Types::BaseInterface

    field :mapping_options, Types::HarvestOptionsMappingType, null: false do
      description <<~TEXT
      Options that control mapping of entities during the harvesting process.
      TEXT
    end

    field :read_options, Types::HarvestOptionsReadType, null: false do
      description <<~TEXT
      Options that control reading from the source.
      TEXT
    end
  end
end
