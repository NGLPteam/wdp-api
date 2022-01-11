# frozen_string_literal: true

RSpec.describe AnnouncementPolicy, type: :policy do
  it_behaves_like "an entity child record policy" do
    let(:record) { FactoryBot.create :announcement, entity: entity }
  end
end
