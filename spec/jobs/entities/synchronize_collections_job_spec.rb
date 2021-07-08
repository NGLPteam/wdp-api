# frozen_string_literal: true

RSpec.describe Entities::SynchronizeCollectionsJob, type: :job do
  let!(:entities) { FactoryBot.create_list :collection, 2 }

  before do
    Entity.where(entity: entities).destroy_all
  end

  it "synchronizes the entities" do
    expect do
      described_class.perform_now
    end.to change(Entity, :count).by(2)
  end
end
