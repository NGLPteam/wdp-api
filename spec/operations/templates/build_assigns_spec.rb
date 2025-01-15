# frozen_string_literal: true

RSpec.describe Templates::BuildAssigns, type: :operation do
  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:collection, refind: true) { FactoryBot.create :collection, community: }
  let_it_be(:item, refind: true) { FactoryBot.create :item, collection: }

  let!(:entity) { community }

  let!(:assigns) { entity.to_liquid_assigns.value! }

  subject { assigns }

  context "when called on nothing" do
    it "produces nothing" do
      expect_calling.to succeed.with(a_kind_of(Hash).and(be_blank))
    end
  end

  context "with a community" do
    let!(:entity) { community }

    it "has the right community drop" do
      expect(assigns["community"].instance_variable_get(:@entity)).to eq community
    end

    it "does not have a parent drop" do
      expect(assigns["parent"]).to be_blank
    end

    it "has the right entity/self drop", :aggregate_failures do
      expect(assigns["self"].instance_variable_get(:@entity)).to eq entity
      expect(assigns["entity"].instance_variable_get(:@entity)).to eq entity
    end
  end

  context "with a collection" do
    let!(:entity) { collection }

    it "has the right community drop" do
      expect(assigns["community"].instance_variable_get(:@entity)).to eq community
    end

    it "has the right parent drop" do
      expect(assigns["parent"].instance_variable_get(:@entity)).to eq community
    end

    it "has the right entity/self drop", :aggregate_failures do
      expect(assigns["self"].instance_variable_get(:@entity)).to eq entity
      expect(assigns["entity"].instance_variable_get(:@entity)).to eq entity
    end
  end

  context "with an item" do
    let!(:entity) { item }

    it "has the right community drop" do
      expect(assigns["community"].instance_variable_get(:@entity)).to eq community
    end

    it "has the right parent drop" do
      expect(assigns["parent"].instance_variable_get(:@entity)).to eq collection
    end

    it "has the right entity/self drop", :aggregate_failures do
      expect(assigns["self"].instance_variable_get(:@entity)).to eq entity
      expect(assigns["entity"].instance_variable_get(:@entity)).to eq entity
    end
  end
end
