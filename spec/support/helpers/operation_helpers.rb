# frozen_string_literal: true

module TestHelpers
  module OperationCalls
    module ExampleHelpers
      extend RSpec::Matchers::DSL

      def expect_calling
        expect(operation.call)
      end

      def expect_calling_with(...)
        expect(operation.call(...))
      end

      matcher :be_the_result_with do |*args|
        match do |actual|
          @expected = operation.call(*args)

          if @expected.success?
            values_match? @expected.value!, actual
          else
            false
          end
        end

        description do
          "be the result of calling #{operation.class.name}(#{inspect_args})"
        end

        define_method :inspect_args do
          inspect_value(args).join(", ")
        end

        def inspect_value(value)
          case value
          when Array then value.map { |v| inspect_value v }
          when Hash then value.transform_values { |v| inspect_value v }
          when Dry::Types["class"].constrained(lt: ActiveRecord::Base)
            "ModelClass(#{value.model_name})"
          when Dry::Types::Nominal.new(ActiveRecord::Base).constrained(type: ActiveRecord::Base)
            "Model(#{value.model_name}##{value.primary_key.inspect})"
          else
            value.inspect
          end
        end
      end
    end
  end
end

RSpec.shared_context "an operation" do
  let(:operation) { described_class.new }
end

RSpec.configure do |config|
  config.include TestHelpers::OperationCalls::ExampleHelpers, type: :operation
  config.include_context "an operation", type: :operation
end
