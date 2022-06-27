# frozen_string_literal: true

RSpec.describe Entities::SynchronizeItemsJob, type: :job do
  it_behaves_like "an entity sync job" do
    let_it_be(:entities) { FactoryBot.create_list :item, 2 }
  end
end
