# frozen_string_literal: true

RSpec.describe Types::HarvestMetadataMappingFieldType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_metadata_mapping_field
end
