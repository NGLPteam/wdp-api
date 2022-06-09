# frozen_string_literal: true

require_relative "../helpers/test_operation"

RSpec.shared_context "skipped orderings by schema" do |*declarations|
  around do |example|
    declarations.flatten!

    versions = declarations.map { |d| SchemaVersion[d] }

    Schemas::Orderings.skip_refresh_for(*versions) do
      example.run
    end
  end
end

RSpec.shared_context "disable ordering refreshes" do
  before(:all) do
    WDPAPI::Container.stub("schemas.instances.refresh_orderings", stubbed_ordering_refresh)
  end

  def stubbed_ordering_refresh
    TestHelpers::TestOperation.new
  end

  after(:all) do
    WDPAPI::Container.unstub("schemas.instances.refresh_orderings")
  end
end

RSpec.configure do |config|
  config.include_context "disable ordering refreshes", disable_ordering_refreshes: true
end
