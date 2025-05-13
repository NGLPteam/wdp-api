# frozen_string_literal: true

RSpec.describe Mutations::HarvestMetadataMappingCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestMetadataMappingCreate($input: HarvestMetadataMappingCreateInput!) {
    harvestMetadataMappingCreate(input: $input) {
      harvestMetadataMapping {
        id
        slug
        field
        pattern
        targetEntity {
          ... on Collection {
            id
          }
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:harvest_source) { FactoryBot.create :harvest_source }

  let_it_be(:target_entity) { FactoryBot.create :collection, :journal }

  let_mutation_input!(:harvest_source_id) { harvest_source.to_encoded_id }
  let_mutation_input!(:field) { "IDENTIFIER" }
  let_mutation_input!(:pattern) { "^some-pattern" }
  let_mutation_input!(:target_entity_id) { target_entity.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_metadata_mapping_create) do |m|
      m.prop(:harvest_metadata_mapping) do |hmm|
        hmm[:id] = be_an_encoded_id.of_an_existing_model
        hmm[:slug] = be_an_encoded_slug
        hmm[:field] = field
        hmm[:pattern] = pattern

        hmm.prop :target_entity do |te|
          te[:id] = target_entity_id
        end
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_metadata_mapping_create
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "creates the harvest metadata mapping" do
      expect_request! do |req|
        req.effect! change(HarvestMetadataMapping, :count).by(1)

        req.data! expected_shape
      end
    end

    context "when upserting" do
      let_it_be(:existing_metadata_mapping) do
        FactoryBot.create(:harvest_metadata_mapping, harvest_source:, field: "identifier", pattern: "^some-pattern")
      end

      it "is idempotent" do
        expect_request! do |req|
          req.effect! keep_the_same(HarvestMetadataMapping, :count)
          req.effect! change { existing_metadata_mapping.reload.target_entity }.to(target_entity)
        end
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(HarvestMetadataMapping, :count)

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
