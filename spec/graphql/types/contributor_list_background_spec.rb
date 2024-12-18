# frozen_string_literal: true

RSpec.describe Types::ContributorListBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :contributor_list_background
end
