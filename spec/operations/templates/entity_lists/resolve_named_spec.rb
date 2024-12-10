# frozen_string_literal: true

RSpec.describe Templates::EntityLists::ResolveNamed, type: :operation do
  include_context "journal hierarchy"

  let_it_be(:template_kind) { "descendant_list" }
  let_it_be(:source_entity) { journal }
  let_it_be(:ordering_identifier) { "volumes" }
  let_it_be(:selection_limit) { 1 }

  let_it_be(:options) do
    {
      ordering_identifier:,
      selection_limit:,
      source_entity:,
      template_kind:,
    }
  end

  it "fetches a list as expected" do
    expect_calling_with(**options).to succeed.with(a_kind_of(Templates::EntityList))

    expect(last_success).to have_attributes(count: 1)
    expect(last_success).not_to be_empty
    expect(last_success).to contain_exactly volume_2
  end
end
