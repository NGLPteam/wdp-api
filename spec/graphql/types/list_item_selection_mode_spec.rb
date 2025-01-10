# frozen_string_literal: true

RSpec.describe Types::ListItemSelectionModeType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :list_item_selection_mode
end
