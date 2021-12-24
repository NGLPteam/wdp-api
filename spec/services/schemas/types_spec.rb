# frozen_string_literal: true

RSpec.describe Schemas::Types do
  describe Schemas::Types::Kind do
    let(:collection) { FactoryBot.create :collection }

    it "works with an Entity" do
      expect(described_class[collection.entity]).to eq "collection"
    end
  end
end
