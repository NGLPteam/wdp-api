# frozen_string_literal: true

RSpec.describe Schemas::Edges::Validate, type: :operation do
  let(:operation) { described_class.new }

  let(:parent) { nil }
  let(:child) { nil }

  let(:community) { "community" }
  let(:collection) { "collection" }
  let(:item) { "item" }
  let(:user) { "user" }

  def expect_the_validation
    expect do |b|
      operation.call(parent, child) do |m|
        m.edge(&b)

        m.unacceptable(&b)

        m.incomprehensible(&b)
      end
    end
  end

  shared_examples_for "a valid edge" do
    it "is valid" do
      expect_the_validation.to yield_with_args(a_kind_of(Schemas::Edges::Edge))
    end
  end

  shared_examples_for "an unacceptable edge" do
    it "is unacceptable" do
      expect_the_validation.to yield_with_args(a_kind_of(Schemas::Edges::Invalid))
    end
  end

  shared_examples_for "an incomprehensible edge" do
    it "is incomprehensible" do
      expect_the_validation.to yield_with_args(a_kind_of(Schemas::Edges::Incomprehensible))
    end
  end

  class << self
    def with_pair!(parent_name, child_name, valid: false, unacceptable: false, incomprehensible: false)
      context "when provided: #{parent_name.inspect}, #{child_name.inspect}" do
        let!(:parent) { __send__(parent_name) if parent_name }
        let!(:child) { __send__(child_name) if child_name }

        it_behaves_like "a valid edge" if valid
        it_behaves_like "an unacceptable edge" if unacceptable
        it_behaves_like "an incomprehensible edge" if incomprehensible
      end
    end
  end

  with_pair! :community, :collection, valid: true
  with_pair! :community, :community, unacceptable: true
  with_pair! :community, :item, unacceptable: true
  with_pair! :item, :community, unacceptable: true
  with_pair! :user, :user, incomprehensible: true
  with_pair! :collection, :collection, valid: true
end
