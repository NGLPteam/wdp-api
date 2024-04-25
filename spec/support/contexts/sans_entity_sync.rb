# frozen_string_literal: true

require_relative "../helpers/test_operation"

RSpec.shared_context "sans entity sync" do
  def fake_entity_sync
    TestHelpers::TestOperation.new
  end

  before(:all) do
    MeruAPI::Container.stub("entities.sync", fake_entity_sync)
  end

  after(:all) do
    MeruAPI::Container.unstub("entities.sync")
  end
end
