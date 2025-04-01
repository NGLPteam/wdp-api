# frozen_string_literal: true

module Mutations
  module Contracts
    class UpdateItem < ApplicationContract
      json do
        required(:item).value(Support::GlobalTypes.Instance(::Item))
        optional(:doi).maybe(:string)
      end

      rule(:item, :doi) do
        key(:doi).failure(:must_be_unique_doi) if Item.has_existing_doi?(values[:doi], except: values[:item])
      end
    end
  end
end
