# frozen_string_literal: true

RSpec.describe ModelMutationSupport do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  subject { user }

  describe "#in_graphql_mutation?" do
    context "when default" do
      it { is_expected.not_to be_in_graphql_mutation }
      it { is_expected.not_to be_graphql_mutation_active }
      it { is_expected.not_to be_pretending_graphql_mutation_active }
    end

    context "when pretending to be in a graphql mutation" do
      around do |example|
        user.pretend_graphql_mutation_active = true

        example.run
      ensure
        user.pretend_graphql_mutation_active = false
      end

      it { is_expected.to be_in_graphql_mutation }
      it { is_expected.not_to be_graphql_mutation_active }
      it { is_expected.to be_pretending_graphql_mutation_active }
    end

    context "when using Mutations.with_active!" do
      around do |example|
        Mutations.with_active! do
          example.run
        end
      end

      it { is_expected.to be_in_graphql_mutation }
      it { is_expected.to be_graphql_mutation_active }
      it { is_expected.not_to be_pretending_graphql_mutation_active }
    end

    context "when using ModelMutationSupport#with_active_mutation!" do
      around do |example|
        user.with_active_mutation! do
          example.run
        end
      end

      it { is_expected.to be_in_graphql_mutation }
      it { is_expected.to be_graphql_mutation_active }
      it { is_expected.not_to be_pretending_graphql_mutation_active }
    end
  end
end
