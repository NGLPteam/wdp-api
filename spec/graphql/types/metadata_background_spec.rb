# frozen_string_literal: true

RSpec.describe Types::MetadataBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :metadata_background
end