# frozen_string_literal: true

RSpec.describe Searching::Origin do
  let_it_be(:schema_version) { SchemaVersion["default:item"] }
  let_it_be(:entity) { FactoryBot.create :collection }
  let_it_be(:ordering) { FactoryBot.create :ordering, entity: }

  let(:input) { nil }

  let(:expected_depth) { 0 }
  let(:expected_relation_count) { ::Entity.count }

  let!(:origin) do
    unless input.nil?
      described_class.new(input)
    else
      described_class.new
    end
  end

  subject { origin }

  shared_examples_for "common methods" do
    describe "#depth" do
      it "matches the expected value" do
        expect(origin.depth).to eq expected_depth
      end
    end

    describe "#relation" do
      it "generates the correct relation count" do
        expect(origin.relation.count).to eq expected_relation_count
      end
    end
  end

  context "with an entity" do
    let(:input) { entity }
    let(:expected_depth) { entity.hierarchical_depth }
    let(:expected_relation_count) { 0 }

    it { is_expected.to be_entity }

    it { is_expected.not_to be_global }
    it { is_expected.not_to be_ordering }
    it { is_expected.not_to be_schema }

    include_examples "common methods"
  end

  context "with an ordering" do
    let(:input) { ordering }

    let(:expected_relation_count) { ordering.normalized_entities.count }

    it { is_expected.to be_ordering }

    it { is_expected.not_to be_global }
    it { is_expected.not_to be_entity }
    it { is_expected.not_to be_schema }

    include_examples "common methods"
  end

  context "with a schema version" do
    let(:input) { schema_version }
    let(:expected_relation_count) { schema_version.entities.real.count }

    it { is_expected.to be_schema }

    it { is_expected.not_to be_entity }
    it { is_expected.not_to be_global }
    it { is_expected.not_to be_ordering }

    include_examples "common methods"
  end

  context "with :global" do
    let(:input) { :global }

    it { is_expected.to be_global }

    it { is_expected.not_to be_entity }
    it { is_expected.not_to be_ordering }
    it { is_expected.not_to be_schema }

    include_examples "common methods"
  end

  context "with nil" do
    let(:input) { nil }

    it { is_expected.to be_global }

    it { is_expected.to have_attributes(depth: 0) }

    it { is_expected.not_to be_entity }
    it { is_expected.not_to be_ordering }
    it { is_expected.not_to be_schema }

    include_examples "common methods"
  end

  describe "Searching::Types::Origin" do
    it "can produce a Searching::Origin based on input", :aggregate_failures do
      expect(Searching::Types::Origin[schema_version]).to be_a_kind_of(described_class).and(be_schema)
      expect(Searching::Types::Origin[entity]).to be_a_kind_of(described_class).and(be_entity)
      expect(Searching::Types::Origin[ordering]).to be_a_kind_of(described_class).and(be_ordering)
      expect(Searching::Types::Origin[nil]).to be_a_kind_of(described_class).and(be_global)
      expect(Searching::Types::Origin[:global]).to be_a_kind_of(described_class).and(be_global)
    end

    it "blows up otherwise" do
      expect do
        Searching::Types::Origin["anything else"]
      end.to raise_error Dry::Types::ConstraintError
    end
  end
end
