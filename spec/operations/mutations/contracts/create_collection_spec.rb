# frozen_string_literal: true

RSpec.describe Mutations::Contracts::CreateCollection, type: :mutation_contract do
  let_local_context!(:schema_version) { SchemaVersion.default_collection }

  let_contract_param!(:schema_version_slug) { "default:collection:latest" }

  let_contract_param!(:parent) { FactoryBot.create :community }

  let_contract_param!(:doi) { "" }

  context "with valid inputs" do
    it { is_expected.to be_a_success }
  end

  context "with an already existing DOI" do
    let_contract_param!(:doi) { "existing" }

    let!(:collection) { FactoryBot.create :collection, doi: }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :doi }
  end

  context "with an unacceptable hierarchy" do
    let_local_context!(:schema_version) { SchemaVersion["nglp:journal_issue"] }

    let_contract_param!(:schema_version_slug) { schema_version.declaration }

    let_contract_param!(:parent) do
      schema = FactoryBot.create :schema_version, :simple_collection

      FactoryBot.create :collection, schema:
    end

    it { is_expected.to be_failure }

    it { is_expected.to be_a_rule_error :parent }
    it { is_expected.to be_a_rule_error :schema_version_slug }
  end
end
