# frozen_string_literal: true

RSpec.shared_context "sans entity sync" do
  let(:fake_entity_sync) do
    proc { Dry::Monads.Success() }
  end

  around do |example|
    WDPAPI::Container.stub("entities.sync", fake_entity_sync) do
      example.run
    end
  end
end
