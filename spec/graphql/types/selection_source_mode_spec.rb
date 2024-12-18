# frozen_string_literal: true

RSpec.describe Types::SelectionSourceModeType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :selection_source_mode
end
