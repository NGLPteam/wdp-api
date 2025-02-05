# frozen_string_literal: true

RSpec.describe Types::ListEntityContextType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :list_entity_context
end
