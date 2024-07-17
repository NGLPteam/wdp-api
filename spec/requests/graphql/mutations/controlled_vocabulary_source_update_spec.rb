# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularySourceUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularySourceUpdate($input: ControlledVocabularySourceUpdateInput!) {
    controlledVocabularySourceUpdate(input: $input) {
      controlledVocabularySource {
        id

        controlledVocabulary {
          id
        }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provides) { "some_test" }

  let_it_be(:existing_controlled_vocabulary_source_attrs) do
    { provides:, }
  end

  let_it_be(:existing_controlled_vocabulary_source, refind: true) { FactoryBot.create(:controlled_vocabulary_source, **existing_controlled_vocabulary_source_attrs) }
  let_it_be(:controlled_vocabulary, refind: true) { FactoryBot.create(:controlled_vocabulary, provides:) }

  let_mutation_input!(:controlled_vocabulary_source_id) { existing_controlled_vocabulary_source.to_encoded_id }
  let_mutation_input!(:controlled_vocabulary_id) { controlled_vocabulary.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:controlled_vocabulary_source_update) do |m|
      m.prop(:controlled_vocabulary_source) do |cvs|
        cvs[:id] = be_an_encoded_id.of_an_existing_model

        cvs.prop :controlled_vocabulary do |cv|
          cv[:id] = controlled_vocabulary_id
        end
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :controlled_vocabulary_source_update
  end

  shared_examples_for "an authorized mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "updates the controlled vocabulary source" do
      expect_request! do |req|
        req.effect! change { ControlledVocabularySource.providing(provides) }.from(nil).to(controlled_vocabulary)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

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
