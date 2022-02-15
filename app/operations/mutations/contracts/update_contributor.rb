# frozen_string_literal: true

module Mutations
  module Contracts
    # A contract that applies when updating any kind of {Contributor}.
    #
    # @see Mutations::Operations::UpdateOrganizationContributor
    # @see Mutations::Operations::UpdatePersonContributor
    class UpdateContributor < ApplicationContract
      json do
        required(:contributor).value(AppTypes.Instance(::Contributor))
        optional(:orcid).maybe(:string)
      end

      rule(:contributor, :orcid) do
        key(:orcid).failure(:must_be_unique_orcid) if Contributor.has_existing_orcid?(values[:orcid], except: values[:contributor])
      end
    end
  end
end
