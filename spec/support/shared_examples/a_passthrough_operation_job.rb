# frozen_string_literal: true

require_relative "../helpers/test_operation"

# A set of examples for jobs that take a single arg (or hash) and pass
# them along to the wrapped operation. They validate that the operation
# was a monadic success and do no other processing on the return value.
RSpec.shared_examples_for "a pass-through operation job" do |operation_path|
  let(:job_arg) do
    raise "Must set job args"
  end

  let(:operation) do
    instance_double(TestHelpers::TestOperation, call: operation_result)
  end

  let(:operation_arg) do
    job_arg
  end

  let(:operation_path) do
    operation_path
  end

  let(:operation_result) do
    Dry::Monads.Success()
  end

  after do
    WDPAPI::Container.unstub operation_path
  end

  def expect_running_the_job
    expect do
      WDPAPI::Container.stub(operation_path, operation) do
        described_class.perform_now job_arg
      end
    end
  end

  context "when the operation is successful" do
    it "calls the operation as expected" do
      expect_running_the_job.to execute_safely

      expect(operation).to have_received(:call).with(operation_arg).once
    end
  end

  context "when the operation is a failure" do
    let(:operation_result) { Dry::Monads.Failure("any failure") }

    it "fails (re-enqueuing the job)" do
      expect_running_the_job.to raise_error Dry::Monads::UnwrapError

      expect(operation).to have_received(:call).with(operation_arg).once
    end
  end
end
