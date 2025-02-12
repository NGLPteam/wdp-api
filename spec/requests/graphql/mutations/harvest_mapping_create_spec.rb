# frozen_string_literal: true

RSpec.describe Mutations::HarvestMappingCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestMappingCreate($input: HarvestMappingCreateInput!) {
    harvestMappingCreate(input: $input) {
      harvestMapping {
        id
        slug
        metadataFormat
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:harvest_source) { FactoryBot.create :harvest_source }
  let_it_be(:target_entity) { FactoryBot.create :community }

  let_mutation_input!(:harvest_source_id) { harvest_source.to_encoded_id }
  let_mutation_input!(:target_entity_id) { target_entity.to_encoded_id }
  let_mutation_input!(:metadata_format) { "JATS" }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_mapping_create) do |m|
      m.prop(:harvest_mapping) do |hm|
        hm[:id] = be_an_encoded_id.of_an_existing_model
        hm[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_mapping_create
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "creates the harvest mapping" do
      expect_request! do |req|
        req.effect! change(HarvestMapping, :count).by(1)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(HarvestMapping, :count)

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
