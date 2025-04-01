# frozen_string_literal: true

module Mutations
  module Contracts
    class UpdateCollection < ApplicationContract
      json do
        required(:collection).value(Support::GlobalTypes.Instance(::Collection))
        optional(:doi).maybe(:string)
      end

      rule(:collection, :doi) do
        key(:doi).failure(:must_be_unique_doi) if Collection.has_existing_doi?(values[:doi], except: values[:collection])
      end
    end
  end
end
