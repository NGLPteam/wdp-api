# frozen_string_literal: true

RSpec.describe PagePolicy, type: :policy do
  it_behaves_like "an entity child record policy" do
    let(:record) { FactoryBot.create :page, entity: }
  end
end
