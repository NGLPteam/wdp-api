# frozen_string_literal: true

RSpec::Matchers.define :have_schema_version do |expected|
  match do |actual|
    schema_version = expected.kind_of?(::SchemaVersion) ? expected : ::SchemaVersion[expected]

    @expected = schema_version.declaration

    @actual = actual.schema_version.declaration

    actual.schema_version == schema_version
  end
end
