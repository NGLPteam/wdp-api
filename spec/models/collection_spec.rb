# frozen_string_literal: true

RSpec.describe Collection, type: :model do
  let!(:collection) { FactoryBot.create :collection }

  it_behaves_like "an entity with a reference"
  it_behaves_like "an entity with schematic properties", :collection
  it_behaves_like "an entity with schematic references", :collection
end
