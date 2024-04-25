# frozen_string_literal: true

RSpec.describe "Query.community", type: :request do
  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:test_collection, refind: true) { FactoryBot.create :collection, community: }

  it_behaves_like "a graphql type with firstCollection" do
    let!(:parent) { community }

    subject { community }
  end

  it_behaves_like "a graphql type with firstItem" do
    let!(:parent) { test_collection }

    subject { community }
  end
end
