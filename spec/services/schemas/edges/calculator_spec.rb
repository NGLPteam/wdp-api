# frozen_string_literal: true

RSpec.describe Schemas::Edges::Calculator do
  def value_for!(parent, child)
    described_class.new(parent, child).call.value!
  end

  let(:parent) { nil }
  let(:child) { nil }

  let(:result) { value_for! parent, child }

  let(:expected_parent_association) { parent&.to_sym }
  let(:expected_child_association) { child&.to_s&.tableize&.to_sym }
  let(:expected_inherited_association) { nil }

  subject { result }

  shared_examples_for "a valid edge" do
    it "has the expected parent association" do
      expect(result.associations.parent).to eq expected_parent_association
    end

    it "has the expected child association" do
      expect(result.associations.child).to eq expected_child_association
    end

    it "inherits as expected" do
      expect(result.associations.inherit).to eq expected_inherited_association
    end

    it "does not both inherit and nullify" do
      expect(result.has_inherited_association?).to xor result.has_nullified_association?
    end
  end

  shared_examples_for "an edge between the same tree-based model" do |inherited|
    let(:expected_parent_association) { :parent }
    let(:expected_child_association) { :children }
    let(:expected_inherited_association) { inherited }

    it { is_expected.to be_a_tree }

    include_examples "a valid edge"
    include_examples "an edge that does not nullify an association"
  end

  shared_examples_for "an edge that nullifies parents" do
    it "nullifies the parent association" do
      expect(result.associations.nullify).to eq :parent
    end
  end

  shared_examples_for "an edge that does not nullify an association" do
    it "does not nullify anything" do
      expect(result.associations.nullify).to be_blank
    end
  end

  context "collection => collection" do
    let(:parent) { "collection" }
    let(:child) { "collection" }

    it_behaves_like "an edge between the same tree-based model", :community
  end

  context "item => item" do
    let(:parent) { "item" }
    let(:child) { "item" }

    it_behaves_like "an edge between the same tree-based model", :collection
  end

  context "community => collection" do
    let(:parent) { "community" }
    let(:child) { "collection" }

    it { is_expected.not_to be_a_tree }

    it_behaves_like "a valid edge"
    include_examples "an edge that nullifies parents"
  end

  context "collection => item" do
    let(:parent) { "collection" }
    let(:child) { "item" }

    it { is_expected.not_to be_a_tree }

    it_behaves_like "a valid edge"
    include_examples "an edge that nullifies parents"
  end
end
