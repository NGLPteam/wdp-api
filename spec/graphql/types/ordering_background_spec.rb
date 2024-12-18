# frozen_string_literal: true

RSpec.describe Types::OrderingBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :ordering_background
end
