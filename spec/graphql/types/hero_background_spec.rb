# frozen_string_literal: true

RSpec.describe Types::HeroBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :hero_background
end
