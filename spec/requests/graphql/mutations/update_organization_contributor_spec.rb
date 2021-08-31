# frozen_string_literal: true

RSpec.describe Mutations::UpdateOrganizationContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :organization, legal_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let!(:mutation_input) do
      {
        contributorId: contributor.to_encoded_id,
        legalName: new_value,
        clearImage: false,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updateOrganizationContributor: {
          contributor: {
            legalName: new_value
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateOrganizationContributor($input: UpdateOrganizationContributorInput!) {
        updateOrganizationContributor(input: $input) {
          contributor {
            legalName
          }

          attributeErrors {
            path
            type
            messages
          }
        }
      }
      GRAPHQL
    end

    it "updates a contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { contributor.reload.properties.organization.legal_name }.from(old_value).to(new_value)

      expect_graphql_response_data expected_shape
    end

    context "when clearing and uploading an image at the same time" do
      let!(:contributor) { FactoryBot.create :contributor, :organization, :with_image }

      let(:image) do
        graphql_upload_from "spec", "data", "lorempixel.jpg"
      end

      let(:mutation_input) do
        super().merge({ clearImage: true, image: image })
      end

      let!(:expected_shape) do
        {
          updateOrganizationContributor: {
            contributor: nil,
            attributeErrors: [
              {
                path: "clearImage",
                messages: ["cannot be set while uploading a new image"]
              }
            ]
          }
        }
      end

      it "does nothing" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to(keep_the_same { contributor.image.id })

        expect_graphql_response_data expected_shape
      end
    end
  end
end
