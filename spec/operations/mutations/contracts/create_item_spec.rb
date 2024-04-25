# frozen_string_literal: true

RSpec.describe Mutations::Contracts::CreateItem, type: :mutation_contract do
  let_local_context!(:schema_version) { SchemaVersion.default_item }

  let_contract_param!(:parent) { FactoryBot.create :collection }

  let_contract_param!(:schema_version_slug) { "default:item:latest" }

  let_contract_param!(:doi) { "" }

  context "with valid inputs" do
    it { is_expected.to be_a_success }
  end

  context "with an already existing DOI" do
    let_contract_param!(:doi) { "existing" }

    let!(:item) { FactoryBot.create :item, doi: }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :doi }
  end

  context "with an unacceptable hierarchy" do
    let_local_context!(:schema_version) { SchemaVersion["nglp:journal_article"] }

    let_contract_param!(:schema_version_slug) { schema_version.declaration }

    let_contract_param!(:parent) do
      schema = SchemaVersion["nglp:journal_volume"]

      FactoryBot.create :collection, schema:
    end

    it { is_expected.to be_failure }

    it { is_expected.to be_a_rule_error :parent }
    it { is_expected.to be_a_rule_error :schema_version_slug }
  end
end
