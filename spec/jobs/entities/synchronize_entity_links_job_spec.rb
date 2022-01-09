# frozen_string_literal: true

RSpec.describe Entities::SynchronizeEntityLinksJob, type: :job do
  it_behaves_like "an entity sync job" do
    let!(:entities) { FactoryBot.create_list :entity_link, 2 }
  end
end
