# frozen_string_literal: true

RSpec.describe "Query.contributor", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getContributor($orgSlug: Slug!, $personSlug: Slug!) {
      organization: contributor(slug: $orgSlug) {
        ... AnyContributorDetailsFragment
      }

      person: contributor(slug: $personSlug) {
        ... AnyContributorDetailsFragment
      }
    }

    fragment AnyContributorDetailsFragment on AnyContributor {
      ... on OrganizationContributor {
        slug

        ... ContributorDetailsFragment
      }

      ... on PersonContributor {
        slug

        ... ContributorDetailsFragment
      }
    }

    fragment ContributorDetailsFragment on Contributor {
      __typename

      kind

      collectionContributions {
        nodes {
          id
        }
      }

      itemContributions {
        nodes { id }
      }
    }
    GRAPHQL
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with a valid slug" do
      let(:graphql_variables) do
        {
          org_slug: org_contributor.system_slug,
          person_slug: person_contributor.system_slug,
        }
      end

      let!(:org_contributor) do
        FactoryBot.create :contributor, :organization
      end

      let!(:person_contributor) do
        FactoryBot.create :contributor, :person
      end

      let(:contributors) { [org_contributor, person_contributor] }

      let!(:expected_shape) do
        a_single_node = { nodes: [{ id: a_kind_of(String) } ] }

        {
          organization: {
            __typename: "OrganizationContributor",
            slug: org_contributor.system_slug,
            collection_contributions: a_single_node,
            item_contributions: a_single_node,
          },
          person: {
            __typename: "PersonContributor",
            slug: person_contributor.system_slug,
            collection_contributions: a_single_node,
            item_contributions: a_single_node,
          }
        }
      end

      before do
        contributors.map do |contrib|
          FactoryBot.create :collection_contribution, contributor: contrib
          FactoryBot.create :item_contribution, contributor: contrib
        end
      end

      it "has the expected shape" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { org_slug: random_slug, person_slug: random_slug } }

      let!(:expected_shape) do
        {
          organization: nil,
          person: nil,
        }
      end

      it "returns nil" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end
  end
end