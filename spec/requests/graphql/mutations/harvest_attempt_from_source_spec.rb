# frozen_string_literal: true

RSpec.describe Mutations::HarvestAttemptFromSource, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestAttemptFromSource($input: HarvestAttemptFromSourceInput!) {
    harvestAttemptFromSource(input: $input) {
      harvestAttempt {
        id
        slug
        mode
        note
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_harvest_source_attrs) do
    {}
  end

  let_it_be(:existing_harvest_source) { FactoryBot.create(:harvest_source, **existing_harvest_source_attrs) }

  let_it_be(:target_entity) { FactoryBot.create :community }

  let_mutation_input!(:harvest_source_id) { existing_harvest_source.to_encoded_id }
  let_mutation_input!(:target_entity_id) { target_entity.to_encoded_id }
  let_mutation_input!(:note) { "Test attempt" }

  let_mutation_input!(:extraction_mapping_template) { Harvesting::Example.default_template_for("oai", "jats") }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_attempt_from_source) do |m|
      m.prop(:harvest_attempt) do |ha|
        ha[:id] = be_an_encoded_id.of_an_existing_model
        ha[:slug] = be_an_encoded_slug
        ha[:mode] = "MANUAL"
        ha[:note] = note
      end
    end
  end

  let(:not_yet_implemented_shape) do
    gql.mutation(:harvest_attempt_from_source, no_errors: false) do |m|
      m[:harvest_attempt] = be_blank

      m.global_errors do |ge|
        ge.error :not_yet_implemented
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_attempt_from_source
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "creates an attempt and enqueues it for extraction" do
      expect_request! do |req|
        req.effect! change(HarvestAttempt, :count).by(1)
        req.effect! have_enqueued_job(Harvesting::ExtractRecordsJob).once

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
