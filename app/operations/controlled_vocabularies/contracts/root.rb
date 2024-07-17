# frozen_string_literal: true

module ControlledVocabularies
  module Contracts
    class Root < ControlledVocabularies::Contracts::Base
      json do
        required(:namespace).value(:namespace)
        required(:identifier).value(:identifier)
        required(:provides).value(:provides)
        required(:name).value(:name)
        required(:version).value(:version)
        optional(:description).maybe(:description)
        required(:items).array(:hash, ControlledVocabularies::Contracts::Item.schema)
      end

      rule(:items).each(contract: ControlledVocabularies::Contracts::Item)

      rule(:items) do
        key.failure(:min_size?, num: 1) unless value.kind_of?(Array) && value.any?
      end
    end
  end
end
