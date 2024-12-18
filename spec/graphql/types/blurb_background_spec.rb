# frozen_string_literal: true

RSpec.describe Types::BlurbBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :blurb_background
end
