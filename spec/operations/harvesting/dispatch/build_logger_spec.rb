# frozen_string_literal: true

RSpec.describe Harvesting::Dispatch::BuildLogger, type: :operation do
  context "with a harvesting attempt" do
    let!(:attempt) { FactoryBot.create :harvest_attempt }

    it "produces the right kind of logger" do
      expect_calling_with(attempt).to succeed.with(a_kind_of(Harvesting::Logs::Attempt).and(have_attributes(model: attempt)))
    end
  end

  context "with a harvesting source" do
    let!(:source) { FactoryBot.create :harvest_source }

    it "produces the right kind of logger" do
      expect_calling_with(source).to succeed.with(a_kind_of(Harvesting::Logs::Source).and(have_attributes(model: source)))
    end
  end

  context "with anything else" do
    it "produces a null logger" do
      expect_calling_with(FactoryBot.create(:user)).to succeed.with(a_kind_of(Harvesting::Logs::Null))
    end
  end
end
