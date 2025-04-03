# frozen_string_literal: true

RSpec.describe OrderingEntryAncestorLink, type: :model do
  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:parent, refind: true) { FactoryBot.create :collection, community:, schema: "nglp:unit" }
  let_it_be(:child, refind: true) { FactoryBot.create :collection, community:, parent:, schema: "nglp:unit" }

  let_it_be(:ordering, refind: true) do
    parent && child

    community.refresh_orderings!

    community.ordering!("units")
  end

  let_it_be(:parent_entry, refind: true) do
    ordering.find_entry! parent
  end

  let_it_be(:child_entry, refind: true) do
    ordering.find_entry! child
  end

  before do
    described_class.delete_all
  end

  specify "the ancestry association is exposed and maintained" do
    expect do
      community.refresh_orderings!
    end.to change(described_class, :count).by_at_least(1)
      .and change { parent_entry.reload.descendants.first&.id }.from(nil).to(child_entry.id)
      .and change { child_entry.reload.ancestors.first&.id }.from(nil).to(parent_entry.id)
  end
end
