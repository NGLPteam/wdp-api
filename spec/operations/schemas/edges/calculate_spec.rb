# frozen_string_literal: true

RSpec.describe Schemas::Edges::Calculate, type: :operation do
  let(:operation) { described_class.new }

  let(:parent) { nil }
  let(:child) { nil }

  let(:community) { "community" }
  let(:collection) { "collection" }
  let(:item) { "item" }

  let(:community_definition) { FactoryBot.create :schema_definition, :simple_community }
  let(:collection_definition) { FactoryBot.create :schema_definition, :simple_collection }
  let(:item_definition) { FactoryBot.create :schema_definition, :simple_item }

  let(:community_version) { FactoryBot.create :schema_version, :simple_community }
  let(:collection_version) { FactoryBot.create :schema_version, :simple_collection }
  let(:item_version) { FactoryBot.create :schema_version, :simple_item }

  let(:community_instance) { FactoryBot.create :community }
  let(:collection_instance) { FactoryBot.create :collection }
  let(:item_instance) { FactoryBot.create :item }

  include_context "cacheable class"

  shared_examples_for "a cached calculation" do
    it "is cached on successive calls" do
      allow(operation).to receive(:call).and_call_original

      expect do
        expect_calling_with(parent, child)
        expect_calling_with(parent, child)
      end.to change(described_class.cache, :size).by(1)

      expect(operation).to have_received(:call).twice
    end
  end

  shared_examples_for "a valid calculation" do
    it "produces an edge" do
      expect_calling_with(parent, child).to succeed.with(a_kind_of(Schemas::Edges::Edge))
    end
  end

  shared_examples_for "an invalid calculation" do
    it "produces an invalid edge" do
      expect_calling_with(parent, child).to monad_fail.with([:unacceptable_edge, a_kind_of(Schemas::Edges::Invalid)])
    end
  end

  shared_examples_for "an explosive calculation" do
    it "raises an error when called" do
      expect do
        expect_calling_with(parent, child)
      end.to raise_error Schemas::Edges::Incomprehensible
    end

    it "does not store a cache entry" do
      expect do
        expect_calling_with(parent, child)
      end.to raise_error(Schemas::Edges::Incomprehensible).and keep_the_same(described_class.cache, :size)
    end
  end

  class << self
    def with_pair!(parent_name, child_name, valid: false, invalid: false, cached: false, explosive: false)
      context "when provided: #{parent_name.inspect}, #{child_name.inspect}" do
        let!(:parent) { __send__(parent_name) if parent_name }
        let!(:child) { __send__(child_name) if child_name }

        it_behaves_like "a valid calculation" if valid
        it_behaves_like "a cached calculation" if cached
        it_behaves_like "an invalid calculation" if invalid
        it_behaves_like "an explosive calculation" if explosive
      end
    end
  end

  with_pair! :community, :collection, valid: true, cached: true
  with_pair! :community, :community, invalid: true
  with_pair! :community, :item, invalid: true

  with_pair! :collection_definition, :collection_version, valid: true
  with_pair! :item_definition, :item, valid: true
  with_pair! :community_version, :community_instance, invalid: true

  with_pair! nil, :collection, explosive: true
  with_pair! :item, nil, explosive: true

  context "when mixing inputs" do
    specify "complex types are simplified before caching" do
      expect do
        expect_calling_with(collection_version, collection)
        expect_calling_with(collection_definition, collection)
        expect_calling_with(collection_instance, collection_version)
      end.to change(described_class.cache, :size).by(1)
    end
  end
end
