# frozen_string_literal: true

RSpec.describe Types::SupplementaryBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :supplementary_background
end
