# frozen_string_literal: true

module ControlledVocabularies
  module Contracts
    class Item < ControlledVocabularies::Contracts::Base
      include Dry::Effects.State(:depth) { 0 }
      include Dry::Effects.State(:item_identifiers) { Set.new }

      MAX_DEPTH = 2

      json do
        required(:identifier).value(:identifier)
        required(:label).value(:label)
        optional(:description).maybe(:description)
        optional(:url).maybe(:url)
        optional(:unselectable).value(:bool)
        optional(:children).array(:hash)
      end

      rule do
        base.failure("is too deep") if depth > MAX_DEPTH
      end

      rule(:children).each do |context:|
        next if value.nil?

        self.depth += 1

        contract_instance = MeruAPI::Container["controlled_vocabularies.contracts.item"]

        contract_result = contract_instance.(value, context)

        unless contract_result.success?
          errors = contract_result.errors

          errors.each do |error|
            key(key.path.to_a + error.path).failure(error.text)
          end
        end
      ensure
        self.depth -= 1
      end

      rule(:identifier) do
        key.failure("is not unique") unless item_identifiers.add?(value)
      end
    end
  end
end
