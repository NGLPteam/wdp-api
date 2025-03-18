# frozen_string_literal: true

RSpec.describe Mutations::HarvestSourceCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestSourceCreate($input: HarvestSourceCreateInput!) {
    harvestSourceCreate(input: $input) {
      harvestSource {
        id
        slug
        protocol
        metadataFormat
        status
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_mutation_input!(:protocol) { "OAI" }
  let_mutation_input!(:metadata_format) { "JATS" }
  let_mutation_input!(:identifier) { "test-harvest-source" }

  let_mutation_input!(:name) { "Test Harvest Source" }
  let_mutation_input!(:base_url) { Harvesting::Testing::ProviderDefinition.oai.first.base_url }
  let_mutation_input!(:extraction_mapping_template) { Harvesting::Example.default_template_for("oai", "jats") }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_source_create) do |m|
      m.prop(:harvest_source) do |hs|
        hs[:id] = be_an_encoded_id.of_an_existing_model
        hs[:slug] = be_an_encoded_slug
        hs[:status] = "ACTIVE"
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_source_create
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "creates the harvest source" do
      expect_request! do |req|
        req.effect! change(HarvestSource, :count).by(1)
        req.effect! have_enqueued_job(Harvesting::Sources::ExtractSetsJob).once

        req.data! expected_shape
      end
    end

    context "when creating with an invalid mapping template" do
      let_mutation_input!(:extraction_mapping_template) { "<mapping" }

      let(:expected_shape) do
        gql.mutation(:harvest_source_create, no_errors: false) do |m|
          m[:harvest_source] = be_blank

          m.attribute_errors do |ae|
            ae.error :extraction_mapping_template, :"extraction_mapping_template.not_well_formed"
          end
        end
      end

      it "does not create the source" do
        expect_request! do |req|
          req.effect! keep_the_same(HarvestSource, :count)

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
        req.effect! keep_the_same(HarvestSource, :count)
        req.effect! have_enqueued_no_jobs(Harvesting::Sources::ExtractSetsJob)

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
