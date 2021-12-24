# frozen_string_literal: true

RSpec.describe Mutations::Contracts::GrantAccess, type: :mutation_contract do
  let!(:current_user) { FactoryBot.create :user }

  let_contract_param!(:user) { FactoryBot.create :user }

  context "when the user is the same" do
    let_contract_param!(:user) { current_user }

    it { is_expected.to be_a_failure }

    it { is_expected.to be_a_rule_error :$global }
  end
end
