# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::HarvestSourceCreate
    # @see Mutations::Operations::HarvestSourceCreate
    class HarvestSourceCreate < MutationOperations::Contract
      json do
        required(:identifier).filled(:string)
        required(:name).filled(:string)
        required(:base_url).filled(:string)
        required(:protocol).value(:harvest_protocol)
        required(:metadata_format).filled(:harvest_metadata_format)
        optional(:description).maybe(:string)
      end

      rule(:base_url).validate(:url_format)

      rule(:identifier).validate(:harvest_identifier_format)

      rule(:identifier) do
        key.failure(:must_be_unique) if value.present? && HarvestSource.exists?(identifier: value)
      end
    end
  end
end
