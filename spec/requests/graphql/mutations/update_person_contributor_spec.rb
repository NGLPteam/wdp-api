# frozen_string_literal: true

RSpec.describe Mutations::UpdatePersonContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person, given_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let(:clear_image) { false }

    let!(:mutation_input) do
      {
        contributorId: contributor.to_encoded_id,
        givenName: new_value,
        familyName: contributor.properties.person.family_name,
        clearImage: clear_image,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updatePersonContributor: {
          contributor: {
            givenName: new_value
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updatePersonContributor($input: UpdatePersonContributorInput!) {
        updatePersonContributor(input: $input) {
          contributor {
            givenName
          }

          errors {
            message
          }
        }
      }
      GRAPHQL
    end

    it "updates a contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { contributor.reload.properties.person.given_name }.from(old_value).to(new_value)

      expect_graphql_response_data expected_shape
    end

    context "when clearing an image" do
      let!(:contributor) { FactoryBot.create :contributor, :person, :with_image }

      let(:clear_image) { true }

      it "removes the image" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change { contributor.reload.image.present? }.from(true).to(false)
      end
    end

    context "when sending image: nil with an existing image" do
      let!(:contributor) { FactoryBot.create :contributor, :person, :with_image }

      let(:mutation_input) do
        super().merge(image: nil)
      end

      it "keeps the image" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to(keep_the_same { contributor.reload.image })
      end
    end
  end
end
