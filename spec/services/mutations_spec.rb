# frozen_string_literal: true

RSpec.describe Mutations do
  describe ".with_active!" do
    let_it_be(:user) { FactoryBot.create :user }

    # @return [Boolean]
    attr_accessor :was_in_graphql_mutation

    before do
      @was_in_graphql_mutation = false
    end

    it "will make a model detect itself as being in a graphql mutation" do
      expect do
        described_class.with_active! do
          @was_in_graphql_mutation = user.in_graphql_mutation?
        end
      end.to change { was_in_graphql_mutation }.from(false).to(true)
    end
  end
end
