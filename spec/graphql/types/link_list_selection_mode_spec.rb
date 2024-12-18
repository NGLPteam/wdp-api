# frozen_string_literal: true

RSpec.describe Types::LinkListSelectionModeType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :link_list_selection_mode
end
