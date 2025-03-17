# frozen_string_literal: true

RSpec.describe Types::HarvestMetadataFormatType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_metadata_format
end
