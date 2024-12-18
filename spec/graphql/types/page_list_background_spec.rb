# frozen_string_literal: true

RSpec.describe Types::PageListBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :page_list_background
end
