# frozen_string_literal: true

RSpec.describe Types::DetailBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :detail_background
end
