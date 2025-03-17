# frozen_string_literal: true

RSpec.describe Types::HarvestProtocolType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_protocol
end
