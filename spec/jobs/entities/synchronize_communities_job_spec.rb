# frozen_string_literal: true

RSpec.describe Entities::SynchronizeCommunitiesJob, type: :job do
  it_behaves_like "an entity sync job" do
    let_it_be(:entities) { FactoryBot.create_list :community, 2 }
  end
end
