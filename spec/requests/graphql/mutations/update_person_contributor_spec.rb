# frozen_string_literal: true

RSpec.describe Mutations::UpdatePersonContributor, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updatePersonContributor($input: UpdatePersonContributorInput!) {
    updatePersonContributor(input: $input) {
      contributor {
        givenName
        orcid
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person, given_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let_mutation_input!(:contributor_id) { contributor.to_encoded_id }
    let_mutation_input!(:given_name) { new_value }
    let_mutation_input!(:family_name) { contributor.properties.person.family_name }
    let_mutation_input!(:clear_image) { false }

    let!(:expected_shape) do
      gql.mutation(:update_person_contributor) do |m|
        m.prop :contributor do |c|
          c[:given_name] = new_value
        end
      end
    end

    it "updates a contributor" do
      expect_the_default_request.to change { contributor.reload.properties.person.given_name }.from(old_value).to(new_value)

      expect_graphql_data expected_shape
    end

    context "when clearing an image" do
      let!(:contributor) { FactoryBot.create :contributor, :person, :with_image }

      let(:clear_image) { true }

      it "removes the image" do
        expect_the_default_request.to change { contributor.reload.image.present? }.from(true).to(false)
      end
    end

    context "when sending image: nil with an existing image" do
      let!(:contributor) { FactoryBot.create :contributor, :person, :with_image }

      let_mutation_input!(:image) { nil }

      it "keeps the image" do
        expect_the_default_request.to(keep_the_same { contributor.reload.image })
      end
    end

    context "when uploading an image" do
      let_mutation_input!(:image) do
        graphql_upload_from "spec", "data", "lorempixel.jpg"
      end

      it "adds the image" do
        expect_the_default_request.to change { contributor.reload.image.present? }.from(false).to(true)
      end
    end

    context "when updating an ORCID" do
      let(:orcid_value) { SecureRandom.uuid }

      let_mutation_input!(:orcid) { orcid_value }

      it "updates the contributor" do
        expect_the_default_request.to change { contributor.reload.orcid }.from(nil).to(orcid_value)
      end

      context "with an already-assigned contributor" do
        let!(:existing_contributor) { FactoryBot.create :contributor, :person, orcid: orcid_value }

        let!(:expected_shape) do
          gql.mutation(:update_person_contributor, no_errors: false) do |m|
            m[:contributor] = nil

            m.attribute_errors do |eb|
              eb.error :orcid, :must_be_unique_orcid
            end
          end
        end

        it "fails to update the contributor" do
          expect_the_default_request.to keep_the_same { contributor.reload.orcid }

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
