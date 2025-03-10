# frozen_string_literal: true

module Harvesting
  module Sets
    # @api private
    # @see Harvesting::Protocols::SetExtractor
    class ValidatePrepared < ApplicationContract
      params do
        required(:identifier).filled(:string)
        required(:name).filled(:string)
        optional(:description).maybe(:string)
      end
    end
  end
end
