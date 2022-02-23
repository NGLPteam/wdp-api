# frozen_string_literal: true

module Mutations
  module Contracts
    # A contract that applies when creating any kind of {Contributor}.
    #
    # @see Mutations::Operations::CreateOrganizationContributor
    # @see Mutations::Operations::CreatePersonContributor
    class CreateContributor < MutationOperations::Contract
      json do
        optional(:orcid).maybe(:string)
      end

      rule(:orcid) do
        key.failure(:must_be_unique_orcid) if Contributor.has_existing_orcid?(values[:orcid])
      end

      rule(:orcid).validate(:orcid_format)
    end
  end
end
