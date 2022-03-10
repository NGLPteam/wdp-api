# frozen_string_literal: true

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
  around do |example|
    Schemas::Orderings.with_disabled_refresh do
      example.run
    end
  end
end

RSpec.shared_context "default skipped orderings" do
  let(:default_skipped_schemas) do
    [SchemaVersion["default:community:1.0.0"]]
  end

  around do |example|
    Schemas::Orderings.skip_refresh_for(*default_skipped_schemas) do
      example.run
    end
  end
end

RSpec.configure do |config|
  config.include_context "default skipped orderings"
  config.include_context "disable ordering refreshes", disable_ordering_refreshes: true
end
