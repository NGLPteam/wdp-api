# frozen_string_literal: true

RSpec.describe Searching::Scope do
  let_it_be(:entity) { FactoryBot.create :collection }
  let_it_be(:expected_schema_version) { entity.schema_version }

  let(:user) { nil }
  let(:origin) { nil }
  let(:visibility) { nil }
  let(:max_depth) { 30 }

  let(:scope) { described_class.new(user:, origin:, visibility:, max_depth:) }

  subject { scope }

  context "when default" do
    it { is_expected.to be_from_global }
    it { is_expected.not_to be_from_entity }
    it { is_expected.not_to be_from_ordering }
    it { is_expected.not_to be_from_schema }
    it { is_expected.to have_attributes(origin_depth: 0, origin_type: :global) }

    describe "#available_schema_versions" do
      it "has available schema versions" do
        expect(scope.available_schema_versions).to include expected_schema_version
      end
    end
  end
end
