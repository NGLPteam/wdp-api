# frozen_string_literal: true

RSpec.describe HarvestSet, type: :model do
  describe ".lookup_by_prefix" do
    let_it_be(:foo_bar) { FactoryBot.create :harvest_set, identifier: "foo:bar" }
    let_it_be(:baz_quux) { FactoryBot.create :harvest_set, identifier: "baz:quux" }

    it "restricts to the right set", :aggregate_failures do
      expect(described_class.lookup_by_prefix("foo:")).to include(foo_bar).and(exclude(baz_quux))
      expect(described_class.lookup_by_prefix("baz:")).to include(baz_quux).and(exclude(foo_bar))
      expect(described_class.lookup_by_prefix("no matching")).to exclude(foo_bar).and(exclude(baz_quux))
      expect(described_class.lookup_by_prefix("")).to include(foo_bar).and(include(baz_quux))
    end
  end
end
