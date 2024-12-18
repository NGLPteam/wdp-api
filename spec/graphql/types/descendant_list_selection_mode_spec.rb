# frozen_string_literal: true

RSpec.describe Types::DescendantListSelectionModeType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :descendant_list_selection_mode
end
