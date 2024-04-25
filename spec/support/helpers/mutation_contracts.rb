# frozen_string_literal: true

require_relative "hash_setter"
require_relative "operation_helpers"

module TestHelpers
  module MutationContracts
    ContractParamsHelpers = TestHelpers::HashSetter.new :contract_params
    LocalContextHelpers = TestHelpers::HashSetter.new :local_context
    ContextEdgesHelpers = TestHelpers::HashSetter.new :local_context_edges

    module ExampleHelpers
      def edge_for!(parent, child)
        Schemas::Edges::Calculator.new(parent, child).call.value!
      end
    end

    module SpecHelpers
      def anonymous!
        let_contract_param!(:current_user) { AnonymousUser.new }
      end

      def set_edge_for!(parent, child, name: :default_edge, key: :edge)
        let_local_context_edge!(name, key:) do
          edge_for! parent, child
        end
      end
    end
  end
end

RSpec.shared_context "mutation contracts" do
  include_context "an operation"

  let(:current_user) { AnonymousUser.new }

  let(:contract_middleware) do
    MutationOperations::ContractMiddleware.new(
      current_user:,
      local_context: local_context.dup,
      edges: local_context_edges.dup,
    )
  end

  let(:contract) { described_class.new }

  let(:contract_result) { contract.call contract_params }

  subject { contract_result }

  around do |example|
    contract_middleware.call do
      example.run
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::OperationCalls::ExampleHelpers, type: :mutation_contract
  config.include TestHelpers::MutationContracts::LocalContextHelpers, type: :mutation_contract
  config.include TestHelpers::MutationContracts::ContractParamsHelpers, type: :mutation_contract
  config.include TestHelpers::MutationContracts::ContextEdgesHelpers, type: :mutation_contract
  config.include TestHelpers::MutationContracts::ExampleHelpers, type: :mutation_contract
  config.extend TestHelpers::MutationContracts::SpecHelpers, type: :mutation_contract
  config.include_context "mutation contracts", type: :mutation_contract
end
