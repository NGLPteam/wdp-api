# frozen_string_literal: true

RSpec.describe Types::DescendantListVariantType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :descendant_list_variant
end
