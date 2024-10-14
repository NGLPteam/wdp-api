# frozen_string_literal: true

RSpec.describe Types::LayoutKindType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :layout_kind
end
