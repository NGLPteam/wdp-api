# frozen_string_literal: true

require_relative "../helpers/test_operation"

# A set of examples for jobs that simply wrap an operation which takes
# no args and requires no special processing for its return type, except
# that it must be a monadic success.
RSpec.shared_examples_for "a void operation job" do |operation_path|
  let(:operation) do
    instance_double(TestHelpers::TestOperation, call: operation_result)
  end

  let(:operation_path) do
    operation_path
  end

  let(:operation_result) do
    Dry::Monads.Success()
  end

  around do |example|
    RSpec::Mocks.with_temporary_scope do
      Common::Container.stub(operation_path, operation) do
        example.run
      end
    end
  end

  after do
    Common::Container.unstub operation_path
  end

  def expect_running_the_job
    expect do
      described_class.perform_now
    end
  end

  context "when the operation is successful" do
    it "calls the operation as expected" do
      expect_running_the_job.to execute_safely

      expect(operation).to have_received(:call).with(no_args).once
    end
  end

  context "when the operation is a failure" do
    let(:operation_result) { Dry::Monads.Failure("any failure") }

    it "fails (re-enqueuing the job)" do
      expect_running_the_job.to raise_error Dry::Monads::UnwrapError

      expect(operation).to have_received(:call).with(no_args).once
    end
  end
end
