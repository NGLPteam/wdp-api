# frozen_string_literal: true

RSpec.describe "Query.community", type: :request do
  it_behaves_like "a graphql type with firstCollection" do
    let!(:community) { FactoryBot.create :community }

    let!(:parent) { community }

    subject { community }
  end

  it_behaves_like "a graphql type with firstItem" do
    let!(:community) { FactoryBot.create :community }

    let!(:parent) { FactoryBot.create :collection, community: community }

    subject { community }
  end
end
