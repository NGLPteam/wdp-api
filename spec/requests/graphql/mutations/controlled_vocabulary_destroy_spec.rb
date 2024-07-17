# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyDestroy($input: ControlledVocabularyDestroyInput!) {
    controlledVocabularyDestroy(input: $input) {
      destroyed
      destroyedId
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_controlled_vocabulary_attrs) do
    {}
  end

  let_it_be(:existing_controlled_vocabulary, refind: true) { FactoryBot.create(:controlled_vocabulary, **existing_controlled_vocabulary_attrs) }
  let_it_be(:builtin_controlled_vocabulary, refind: true) { FactoryBot.create(:controlled_vocabulary, :default_namespace) }

  let_mutation_input!(:controlled_vocabulary_id) { existing_controlled_vocabulary.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:controlled_vocabulary_destroy) do |m|
      m[:destroyed] = true
      m[:destroyed_id] = be_an_encoded_id.of_a_deleted_model
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :controlled_vocabulary_destroy
  end

  shared_examples_for "an authorized mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "destroys the controlled vocabulary" do
      expect_request! do |req|
        req.effect! change(ControlledVocabulary, :count).by(-1)

        req.data! expected_shape
      end
    end

    context "when trying to destroy a built-in CV" do
      let_mutation_input!(:controlled_vocabulary_id) { builtin_controlled_vocabulary.to_encoded_id }

      let(:expected_shape) do
        gql.mutation(:controlled_vocabulary_destroy, no_errors: false) do |m|
          m[:destroyed] = be_blank
          m[:destroyed_id] = be_blank

          m.global_errors do |ge|
            ge.error(/default/)
          end
        end
      end

      it "does not destroy the CV" do
        expect_request! do |req|
          req.effect! keep_the_same(ControlledVocabulary, :count)

          req.data! expected_shape
        end
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(ControlledVocabulary, :count)

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    it_behaves_like "an authorized mutation"
  end

  as_an_anonymous_user do
    it_behaves_like "an unauthorized mutation"
  end
end
