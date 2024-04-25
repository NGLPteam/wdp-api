# frozen_string_literal: true

# Use it like this:
#
#     MyContract = Dry::Validation.Contract do
#       params do
#         # for a hash:
#         required(:a).hash(OtherContract.schema)
#
#         # for an array of hashes:
#         required(:b).array(:hash, OtherContract.schema)
#       end
#
#       rule(:a).validate(contract: OtherContract)
#       rule(:b).each(contract: OtherContract)
#     end
#
Dry::Validation.register_macro(:contract) do |macro:, context:|
  next if value.nil? # skip if not a hash

  contract_instance = macro.args[0].then do |contract|
    contract.kind_of?(Class) ? contract.new : contract
  end

  contract_result = contract_instance.(value, context)

  unless contract_result.success?
    errors = contract_result.errors

    errors.each do |error|
      key(key.path.to_a + error.path).failure(error.text)
    end
  end
end
