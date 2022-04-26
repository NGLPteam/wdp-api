# frozen_string_literal: true

Dry::Logic::Predicates.predicate :blank? do |input|
  input.blank?
end

Dry::Logic::Predicates.predicate :email? do |input|
  format? URI::MailTo::EMAIL_REGEXP, input
end

gid_uri = URI::DEFAULT_PARSER.make_regexp("gid")

Dry::Logic::Predicates.predicate :global_id_uri? do |input|
  str?(input) && format?(gid_uri, input)
end

Dry::Logic::Predicates.predicate :global_id? do |input|
  return false if blank?(input) || !(global_id_uri?(input) || type?(::GlobalID, input))

  gid = GlobalID.parse input

  return false if gid.blank?

  begin
    gid.model_class.present?
  rescue NameError
    false
  end
end

http_pattern = URI::DEFAULT_PARSER.make_regexp(/https?/)

Dry::Logic::Predicates.predicate :http_uri? do |input|
  str?(input) && format?(http_pattern, input)
end

https_pattern = URI::DEFAULT_PARSER.make_regexp("https")

Dry::Logic::Predicates.predicate :https_uri? do |input|
  str?(input) && format?(https_pattern, input)
end

Dry::Logic::Predicates.predicate :inherits? do |parent, input|
  type?(Class, input) && input < parent
end

Dry::Logic::Predicates.predicate :model? do |input|
  type?(ActiveRecord::Base, input)
end

Dry::Logic::Predicates.predicate :model_list? do |input|
  array?(input) && input.all? { |elm| model? elm }
end

Dry::Logic::Predicates.predicate :model_class? do |input|
  inherits?(ActiveRecord::Base, input)
end

Dry::Logic::Predicates.predicate :model_class_list? do |input|
  array?(input) && input.all? { |elm| model_class?(input) }
end

Dry::Logic::Predicates.predicate :opaque_id? do |input|
  return false unless str?(input) && WDPAPI::Container[:node_verifier].valid_message?(input)

  WDPAPI::Container["relay_node.decode"].call(input).success?
end

Dry::Logic::Predicates.predicate :present? do |input|
  input.present?
end

Dry::Logic::Predicates.predicate :schematic_collected_references? do |input|
  model_list? input
end

Dry::Logic::Predicates.predicate :schematic_scalar_reference? do |input|
  model? input
end

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
