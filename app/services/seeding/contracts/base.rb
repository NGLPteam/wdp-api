# frozen_string_literal: true

module Seeding
  module Contracts
    # @abstract
    class Base < ApplicationContract
      config.types = Seeding::TypeRegistry

      register_macro(:recursive_collections) do |context:|
        contract = Seeding::Contracts::CollectionImport.new

        arr = Array(value)

        has_errors = false

        remapped = arr.map.with_index do |raw, i|
          result = contract.(raw, context)

          next result.to_h if result.success?

          has_errors = true

          errors = result.errors

          errors.each do |error|
            key(key.path.to_a + [i] + error.path).failure(error.text)
          end
        end

        values[:collections] = remapped unless has_errors
      end

      register_macro(:properties_contract) do |macro:, context:|
        next if schema_error?(key.path) || value.blank?

        contract_instance = macro.args[0].then do |contract|
          contract.kind_of?(Class) ? contract.new : contract
        end

        contract_result = contract_instance.(value, context)

        unless contract_result.success?
          errors = contract_result.errors

          base_path = key.path.to_a[0...-1] + %i[properties]

          errors.each do |error|
            key(base_path + error.path).failure(error.text)
          end
        end
      end
    end
  end
end
