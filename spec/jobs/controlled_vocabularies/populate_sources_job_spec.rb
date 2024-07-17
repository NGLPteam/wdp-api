# frozen_string_literal: true

RSpec.describe ControlledVocabularies::PopulateSourcesJob, type: :job do
  it "executes safely" do
    expect do
      described_class.perform_now
    end.to execute_safely
  end
end
