# frozen_string_literal: true

RSpec.describe Mutations::HarvestMappingUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestMappingUpdate($input: HarvestMappingUpdateInput!) {
    harvestMappingUpdate(input: $input) {
      harvestMapping {
        id
        slug
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_harvest_mapping_attrs) do
    {}
  end

  let_it_be(:existing_harvest_mapping) { FactoryBot.create(:harvest_mapping, **existing_harvest_mapping_attrs) }

  let_it_be(:target_entity) { FactoryBot.create :community }

  let_mutation_input!(:harvest_mapping_id) { existing_harvest_mapping.to_encoded_id }
  let_mutation_input!(:target_entity_id) { target_entity.to_encoded_id }
  let_mutation_input!(:extraction_mapping_template) { Harvesting::Example.default_template_for("oai", "jats") }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_mapping_update) do |m|
      m.prop(:harvest_mapping) do |hm|
        hm[:id] = be_an_encoded_id.of_an_existing_model
        hm[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_mapping_update
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "updates the harvest mapping" do
      expect_request! do |req|
        req.effect! keep_the_same(HarvestMapping, :count)

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
    it_behaves_like "a successful mutation"
  end

  as_an_anonymous_user do
    it_behaves_like "an unauthorized mutation"
  end
end
