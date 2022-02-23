# frozen_string_literal: true

RSpec.describe Roles::DumpCalculatedSystemRoles, type: :operation do
  let(:filesystem) { Dry::Files.new memory: true }

  let(:dump_path) { described_class::DUMP_PATH.to_s }

  let(:operation) { described_class.new filesystem: filesystem }

  it "writes the YAML file" do
    expect do
      expect_calling.to succeed
    end.to change { filesystem.exist? dump_path }.from(false).to(true)
  end
end
