# frozen_string_literal: true

RSpec.describe Types::HarvestMessageLevelType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :harvest_message_level
end
