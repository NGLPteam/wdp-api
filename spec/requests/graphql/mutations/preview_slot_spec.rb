# frozen_string_literal: true

RSpec.describe Mutations::PreviewSlot, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation PreviewSlot($input: PreviewSlotInput!) {
    previewSlot(input: $input) {
      slot {
        __typename
        kind
        content
        valid
        errors {
          lineNumber
          markupContext
          message
        }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_entity_attrs) do
    {}
  end

  let_it_be(:existing_entity) { FactoryBot.create(:collection, **existing_entity_attrs) }

  let_mutation_input!(:entity_id) { existing_entity.to_encoded_id }
  let_mutation_input!(:kind) { "BLOCK" }
  let_mutation_input!(:template) do
    <<~LIQUID.strip_heredoc.strip
    # TITLE: {{entity.title}}

    {% sblist %}
      {% sbitem icon: "TEST", url: "http://example.com" %}
        test label
      {% endsbitem %}
    {% endsblist %}

    {% mdvalue entity.title %}
    {{ entity.title }}
    {% endmdvalue %}

    {% mdpair 'Published' %}
    {{ entity.published }}
    {% endmdpair %}

    {{ entity.thumbnail }}
    LIQUID
  end

  let(:valid_mutation_shape) do
    gql.mutation(:preview_slot) do |m|
      m.prop(:slot) do |e|
        e[:content] = include("TITLE: #{existing_entity.title}")
        e[:kind] = kind
        e[:valid] = true
        e[:errors] = be_blank
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :preview_slot
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "renders a slot preview for the provided entity" do
      expect_request! do |req|
        req.effect! execute_safely

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
