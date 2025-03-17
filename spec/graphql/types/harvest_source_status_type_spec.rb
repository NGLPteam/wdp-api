# frozen_string_literal: true

RSpec.describe Types::HarvestSourceStatusType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_source_status
end
