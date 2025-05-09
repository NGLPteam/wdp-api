# frozen_string_literal: true

RSpec.describe Mutations::HarvestSourceDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestSourceDestroy($input: HarvestSourceDestroyInput!) {
    harvestSourceDestroy(input: $input) {
      destroyed
      destroyedId
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

  let_it_be(:harvest_source_attrs) do
    {}
  end

  let_it_be(:harvest_source, refind: true) { FactoryBot.create(:harvest_source, :oai, :jats, **harvest_source_attrs) }

  let_it_be(:extraction_mapping_template) { harvest_source.extraction_mapping_template }

  let_it_be(:harvest_mapping, refind: true) { FactoryBot.create(:harvest_mapping, harvest_source:, target_entity:, extraction_mapping_template:) }

  let_it_be(:harvest_attempt, refind: true) do
    harvest_mapping.create_attempt!(extraction_mapping_template:, target_entity:).tap do |attempt|
      attempt.extract_records!
    end
  end

  let_mutation_input!(:harvest_source_id) { harvest_source.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_source_destroy) do |m|
      m[:destroyed] = true
      m[:destroyed_id] = harvest_source_id
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_source_destroy
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "destroys the harvest source" do
      expect_request! do |req|
        req.effect! change(HarvestSource, :count).by(-1)
        req.effect! change(HarvestMapping, :count)
        req.effect! change(HarvestAttempt, :count).by(-1)
        req.effect! change(HarvestConfiguration, :count).by(-1)
        req.effect! change(HarvestRecord, :count).by(-108)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! keep_the_same(HarvestSource, :count)

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    it_behaves_like "a successful mutation"
  end

  as_an_anonymous_user do
    it_behaves_like "an unauthorized mutation"
  end
end
