# frozen_string_literal: true

RSpec.describe Mutations::RenderLayouts, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation RenderLayouts($input: RenderLayoutsInput!) {
    renderLayouts(input: $input) {
      entity {
        ... on Community {
          id
          slug

          layouts {
            main {
              lastRenderedAt
            }
          }
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_entity_attrs) do
    {}
  end

  let_it_be(:existing_entity) { FactoryBot.create(:community, **existing_entity_attrs) }

  let_mutation_input!(:entity_id) { existing_entity.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:render_layouts) do |m|
      m.prop(:entity) do |e|
        e[:id] = be_an_encoded_id.of_an_existing_model
        e[:slug] = be_an_encoded_slug

        e.prop :layouts do |l|
          l.prop :main do |main|
            main[:last_rendered_at] = be_present
          end
        end
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :render_layouts
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "updates the entity" do
      expect_request! do |req|
        req.effect! change { existing_entity.reload_main_layout_instance&.last_rendered_at }

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
