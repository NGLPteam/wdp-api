# frozen_string_literal: true

module Mutations
  module Contracts
    class CreateCollection < ApplicationContract
      json do
        required(:schema_version_slug).filled(:string)

        optional(:doi).maybe(:string)
      end

      rule(:doi) do
        key.failure(:must_be_unique_doi) if Collection.has_existing_doi?(values[:doi])
      end
    end
  end
end
