# frozen_string_literal: true

RSpec.describe Types::ChildEntityKindType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :child_entity_kind
end
