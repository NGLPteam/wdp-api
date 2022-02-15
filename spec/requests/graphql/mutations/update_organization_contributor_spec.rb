# frozen_string_literal: true

RSpec.describe Mutations::UpdateOrganizationContributor, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updateOrganizationContributor($input: UpdateOrganizationContributorInput!) {
    updateOrganizationContributor(input: $input) {
      contributor {
        legalName
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :organization, legal_name: old_value }

    let!(:old_value) { Faker::Lorem.unique.sentence }

    let!(:new_value) { Faker::Lorem.unique.sentence }

    let_mutation_input!(:contributor_id) { contributor.to_encoded_id }
    let_mutation_input!(:legal_name) { new_value }
    let_mutation_input!(:clear_image) { false }

    let!(:expected_shape) do
      gql.mutation :update_organization_contributor do |m|
        m.prop :contributor do |c|
          c[:legal_name] = new_value
        end
      end
    end

    it "updates a contributor" do
      expect_the_default_request.to change { contributor.reload.properties.organization.legal_name }.from(old_value).to(new_value)

      expect_graphql_data expected_shape
    end

    context "when clearing and uploading an image at the same time" do
      let!(:contributor) { FactoryBot.create :contributor, :organization, :with_image }

      let_mutation_input!(:image) do
        graphql_upload_from "spec", "data", "lorempixel.jpg"
      end

      let(:clear_image) { true }

      let!(:expected_shape) do
        gql.mutation :update_organization_contributor, no_errors: false do |c|
          c[:contributor] = nil

          c.attribute_errors do |eb|
            eb.error "image", :update_and_clear_attachment
          end
        end
      end

      it "does nothing" do
        expect_the_default_request.to keep_the_same { contributor.image.id }

        expect_graphql_data expected_shape
      end
    end
  end
end
