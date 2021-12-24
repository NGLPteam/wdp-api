# frozen_string_literal: true

RSpec.describe Mutations::Contracts::ReparentEntity, type: :mutation_contract do
  let!(:current_user) { FactoryBot.create :user }

  let(:default_item_schema) { SchemaVersion["default:item:1.0.0"] }

  let(:volume_schema) { SchemaVersion["nglp:journal_volume:1.0.0"] }

  let(:issue_schema) { SchemaVersion["nglp:journal_issue:1.0.0"] }

  let(:article_schema) { SchemaVersion["nglp:journal_article:1.0.0"] }

  let(:article_parent) { FactoryBot.create :collection, schema: issue_schema }

  let(:volume) { FactoryBot.create :collection, schema: volume_schema }

  let(:issue) { FactoryBot.create :collection, schema: issue_schema }

  let(:article) { FactoryBot.create :item, schema: article_schema }

  let(:default_item) { FactoryBot.create :item, schema: default_item_schema }

  let_contract_param!(:user) { FactoryBot.create :user }

  context "with compatible entities" do
    let_contract_param!(:parent) { issue }
    let_contract_param!(:child) { article }

    it { is_expected.to be_a_success }
  end

  context "with mutually incompatible entities" do
    let_contract_param!(:parent) { volume }
    let_contract_param!(:child) { article }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :child }
    it { is_expected.to be_a_rule_error :parent }
  end

  context "with the same entity" do
    let_contract_param!(:parent) { default_item }
    let_contract_param!(:child) { default_item }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :child }
  end

  context "with an inverted hierarchy" do
    let(:collection) { FactoryBot.create :collection }
    let(:subcollection) { FactoryBot.create :collection, parent: collection }
    let(:descendant) { FactoryBot.create :collection, parent: subcollection }

    set_edge_for! :collection, :collection

    let_contract_param!(:parent) { descendant }
    let_contract_param!(:child) { collection }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :child }
  end
end
