# frozen_string_literal: true

RSpec.describe Mutations::Contracts::AlterSchemaVersion, type: :mutation_contract do
  let(:entity_parent) { FactoryBot.create :collection }
  let_local_context!(:schema_version) { SchemaVersion.default_item }
  let_contract_param!(:entity) { FactoryBot.create :item, collection: entity_parent }
  let_contract_param!(:schema_version_slug) { schema_version.declaration }

  context "with valid inputs" do
    it { is_expected.to be_a_success }
  end

  context "with a parent that won't accept the child" do
    let!(:simple_collection_schema) { FactoryBot.create :schema_version, :simple_collection, :v1 }

    let!(:entity_parent) { FactoryBot.create :collection, schema: simple_collection_schema }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :entity }

    it { is_expected.not_to be_a_rule_error :schema_version_slug }
  end

  context "with a schema that won't accept the parent" do
    let_local_context!(:schema_version) { SchemaVersion["nglp:journal_article"] }

    it { is_expected.to be_a_failure }

    it { is_expected.not_to be_a_rule_error :entity }

    it { is_expected.to be_a_rule_error :schema_version_slug }
  end

  context "with mutually unacceptable schema errors" do
    let!(:simple_collection_schema) { FactoryBot.create :schema_version, :simple_collection, :v1 }

    let!(:entity_parent) { FactoryBot.create :collection, schema: simple_collection_schema }

    let_local_context!(:schema_version) { SchemaVersion["nglp:journal_article"] }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :entity }

    it { is_expected.to be_a_rule_error :schema_version_slug }
  end
end
