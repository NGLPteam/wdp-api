# frozen_string_literal: true

Dry::Logic::Predicates.predicate :schematic_collected_references? do |input|
  model_list? input
end

Dry::Logic::Predicates.predicate :schematic_scalar_reference? do |input|
  model? input
end
