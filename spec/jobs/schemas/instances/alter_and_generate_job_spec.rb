# frozen_string_literal: true

RSpec.describe Schemas::Instances::AlterAndGenerateJob, type: :job do
  let!(:entity) { FactoryBot.create :item }

  let!(:new_version) { SchemaVersion["nglp:article"] }

  before do
    FactoryBot.create_list :contributor, 5, :person
  end

  it "works as expected" do
    expect do
      described_class.perform_now entity, new_version
    end.to execute_safely
  end
end
