# frozen_string_literal: true

RSpec.describe Types::LinkListBackgroundType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :link_list_background
end
