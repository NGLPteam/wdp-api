# frozen_string_literal: true

RSpec.describe Types::ContributorListFilterType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :contributor_list_filter
end
