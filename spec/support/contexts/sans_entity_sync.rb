# frozen_string_literal: true

require_relative "../helpers/test_operation"

RSpec.shared_context "sans entity sync" do
  def fake_entity_sync
    TestHelpers::TestOperation.new
  end

  before(:all) do
    WDPAPI::Container.stub("entities.sync", fake_entity_sync)
  end

  after(:all) do
    WDPAPI::Container.unstub("entities.sync")
  end
end
