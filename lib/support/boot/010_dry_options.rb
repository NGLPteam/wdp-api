# frozen_string_literal: true

# We need this because we have a model named `Format`, which older dry.rb code tried to do clever things with.
# Recent dry-rb no longer does.
Dry::Schema::PredicateInferrer::Compiler.infer_predicate_by_class_name false
Dry::Types::PredicateInferrer::Compiler.infer_predicate_by_class_name false

Dry::Schema.load_extensions :hints
Dry::Schema.load_extensions :info
Dry::Schema.load_extensions :monads
Dry::Types.load_extensions :monads
Dry::Validation.load_extensions :monads
Dry::Validation.load_extensions :predicates_as_macros
