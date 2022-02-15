# frozen_string_literal: true

RSpec.describe Mutations::CreateOrganizationContributor, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation createOrganizationContributor($input: CreateOrganizationContributorInput!) {
    createOrganizationContributor(input: $input) {
      contributor {
        kind
        image {
          original {
            storage
            url
          }

          thumb {
            png {
              storage
              url
            }
          }
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let_mutation_input!(:url) { Faker::Internet.url }
    let_mutation_input!(:bio) { Faker::Lorem.paragraphs(number: 4).join("\n") }

    let_mutation_input!(:links) do
      2.times.map do
        { title: Faker::Lorem.sentence, url: Faker::Internet.url }
      end
    end

    # organization-specific properties
    let_mutation_input!(:legal_name) { Faker::Company.name }
    let_mutation_input!(:location) { Faker::Address.full_address }
    let_mutation_input!(:image) { nil }

    let!(:expected_shape) do
      gql.mutation :create_organization_contributor do |m|
        m.prop :contributor do |c|
          c[:kind] = "organization"
        end
      end
    end

    it "creates an organization contributor" do
      expect_the_default_request.to change(Contributor, :count).by(1)

      expect_graphql_data expected_shape
    end

    context "with an invalid link" do
      let(:links) do
        [{ title: "Some Link", url: "bad://link" }]
      end

      let!(:expected_shape) do
        gql.mutation :create_organization_contributor, no_errors: false do |m|
          m[:contributor] = nil

          m.attribute_errors do |eb|
            eb.error "links.0.url", :must_be_url
          end
        end
      end

      it "does not create the contributor" do
        expect_the_default_request.to keep_the_same(Contributor, :count)

        expect_graphql_data expected_shape
      end
    end

    context "with an upload" do
      let(:image) do
        graphql_upload_from "spec", "data", "lorempixel.jpg"
      end

      let!(:expected_shape) do
        gql.mutation :create_organization_contributor do |m|
          m.prop :contributor do |c|
            c[:kind] = "organization"

            c.prop :image do |img|
              img.prop :original do |orig|
                orig[:storage] = "CACHE"
                orig[:url] = be_present
              end

              # Styles won't be processed yet
              img.prop :thumb do |thumb|
                thumb.prop :png do |png|
                  png[:storage] = nil
                  png[:url] = be_blank
                end
              end
            end
          end
        end
      end

      it "creates an organization contributor with an image" do
        expect_the_default_request.to change(Contributor, :count).by(1)

        expect_graphql_data expected_shape
      end
    end

    context "with an already existing ORCID" do
      let(:orcid_value) { SecureRandom.uuid }

      let_mutation_input!(:orcid) { orcid_value }

      let!(:existing_contributor) { FactoryBot.create :contributor, :person, orcid: orcid_value }

      let!(:expected_shape) do
        gql.mutation(:create_organization_contributor, no_errors: false) do |m|
          m[:contributor] = nil

          m.attribute_errors do |eb|
            eb.error :orcid, :must_be_unique_orcid
          end
        end
      end

      it "does not create the contributor" do
        expect_the_default_request.to keep_the_same(Contributor, :count)

        expect_graphql_data expected_shape
      end
    end
  end
end
