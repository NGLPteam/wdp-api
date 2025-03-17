# frozen_string_literal: true

RSpec.describe Types::HarvestRecordStatusType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_record_status
end
