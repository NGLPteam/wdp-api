# frozen_string_literal: true

RSpec.describe NamedVariableDate, type: :model do
  describe ".global_path_for" do
    let(:name) { "foo" }
    let(:wrapped) { "$foo$" }

    it "wraps a path" do
      expect(described_class.global_path_for(name)).to eq wrapped
    end

    it "does not double-wrap a path" do
      expect(described_class.global_path_for(wrapped)).to eq wrapped
    end
  end

  describe ".sort_join_for" do
    def calling_with(value, path = "$published$", dir = "asc")
      described_class.sort_join_for(value, path, dir)
    end

    def be_a_valid_sort_join
      include_json [
        a_kind_of(Arel::Nodes::Join),
        a_kind_of(Arel::Nodes::Ordering),
        a_kind_of(Arel::Nodes::Ordering)
      ]
    end

    it "generates a sort order for Entity" do
      expect(calling_with(Entity)).to be_a_valid_sort_join
    end

    it "generates a sort order for Collection" do
      expect(calling_with(Collection)).to be_a_valid_sort_join
    end

    it "generates a sort order for Item" do
      expect(calling_with(Item)).to be_a_valid_sort_join
    end

    it "generates a sort order for OrderingEntry" do
      expect(calling_with(OrderingEntry)).to be_a_valid_sort_join
    end

    it "raises an error with something that does not reference named variables" do
      expect do
        calling_with User
      end.to raise_error RuntimeError, /reference/
    end

    it "catches an undefined :named_variable_dates association" do
      expect do
        klass = Class.new(ApplicationRecord)

        klass.include ReferencesNamedVariableDates

        calling_with klass
      end.to raise_error ActiveRecord::InverseOfAssociationNotFoundError
    end
  end
end
