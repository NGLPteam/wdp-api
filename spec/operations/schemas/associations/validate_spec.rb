# frozen_string_literal: true

RSpec.describe Schemas::Associations::Validate, type: :operation do
  def have_a_valid_connection
    succeed.with a_kind_of Schemas::Associations::Validation::ValidConnection
  end

  def have_an_invalid_child
    monad_fail.with(a_kind_of(Schemas::Associations::Validation::InvalidChild))
  end

  def have_an_invalid_parent
    monad_fail.with(a_kind_of(Schemas::Associations::Validation::InvalidParent))
  end

  def mutually_fail
    monad_fail.with(a_kind_of(Schemas::Associations::Validation::MutuallyInvalidConnection))
  end

  context "with a schema that can infinitely nest itself" do
    let!(:schema) { FactoryBot.create :schema_version, :simple_collection, :v1 }

    it "succeeds" do
      expect_calling_with(schema, schema).to have_a_valid_connection
    end
  end

  context "with mutually incompatible schemas" do
    let!(:journal_volume) { SchemaVersion["nglp:journal_volume:1.0.0"] }
    let!(:journal_article) { SchemaVersion["nglp:journal_article:1.0.0"] }

    specify "an article cannot be nested directly under a volume" do
      expect_calling_with(journal_volume, journal_article).to mutually_fail
    end
  end

  context "with an invalid child" do
    let!(:simple_collection) { FactoryBot.create :schema_version, :simple_collection, :v1 }
    let!(:default_item) { SchemaVersion["default:item:1.0.0"] }

    specify "simple_collections want simple_items" do
      expect_calling_with(simple_collection, default_item).to have_an_invalid_child
    end
  end

  context "with an invalid parent" do
    let!(:default_collection) { SchemaVersion["default:collection:1.0.0"] }
    let!(:simple_item) { FactoryBot.create :schema_version, :simple_item, :v1 }

    specify "simple_items want to belong to simple_collections" do
      expect_calling_with(default_collection, simple_item).to have_an_invalid_parent
    end
  end

  context "with a version specification" do
    let!(:simple_collection_v1) { FactoryBot.create :schema_version, :simple_collection, :v1 }
    let!(:simple_collection_v2) { FactoryBot.create :schema_version, :simple_collection, :v2 }
    let!(:simple_item_v1) { FactoryBot.create :schema_version, :simple_item, :v1 }
    let!(:simple_item_v2) { FactoryBot.create :schema_version, :simple_item, :v2 }

    specify "new simple_collections do not want old simple_items" do
      expect_calling_with(simple_collection_v2, simple_item_v1).to have_an_invalid_child
    end

    specify "new simple_collections will accept new simple_items" do
      expect_calling_with(simple_collection_v2, simple_item_v2).to have_a_valid_connection
    end

    specify "old simple_collections will accept new simple_items" do
      expect_calling_with(simple_collection_v1, simple_item_v2).to have_a_valid_connection
    end
  end
end
