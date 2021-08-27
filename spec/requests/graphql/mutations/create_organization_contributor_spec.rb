# frozen_string_literal: true

RSpec.describe Mutations::CreateOrganizationContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:url) { Faker::Internet.url }
    let!(:bio) { Faker::Lorem.paragraphs(number: 4).join("\n") }

    let!(:links) do
      2.times.map do
        { title: Faker::Lorem.sentence, url: Faker::Internet.url }
      end
    end

    let(:properties) do
      {
        legalName: Faker::Company.name,
        location: Faker::Address.full_address,
      }
    end

    let(:image) do
      nil
    end

    let!(:mutation_input) do
      {
        image: image,
        url: url,
        bio: bio,
        links: links,
      }.merge(properties)
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createOrganizationContributor: {
          contributor: {
            kind: "organization"
          },

          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createOrganizationContributor($input: CreateOrganizationContributorInput!) {
        createOrganizationContributor(input: $input) {
          contributor {
            kind
            image {
              thumb {
                png {
                  url
                }
              }
            }
          }

          errors {
            message
          }

          attributeErrors {
            messages
            path
            type
          }
        }
      }
      GRAPHQL
    end

    it "creates an organization contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Contributor, :count).by(1)

      expect_graphql_response_data expected_shape
    end

    context "with an invalid link" do
      let(:links) do
        [{ title: "Some Link", url: "bad://link" }]
      end

      let!(:expected_shape) do
        {
          createOrganizationContributor: {
            contributor: be_blank,

            attributeErrors: [
              path: "links.0.url", messages: [/url/i]
            ]
          }
        }
      end

      it "does not create the contributor" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Contributor, :count)

        expect_graphql_response_data expected_shape
      end
    end

    context "with an upload" do
      let!(:uploaded_file) do
        Rails.root.join("spec", "data", "lorempixel.jpg").open "r+" do |f|
          f.binmode

          Shrine.upload(f, :cache)
        end
      end

      let(:image) do
        uploaded_file.as_json.merge(storage: "CACHE").deep_transform_keys do |k|
          k.to_s.camelize(:lower)
        end.tap do |h|
          h["metadata"].delete "size"
        end
      end

      let!(:expected_shape) do
        {
          createOrganizationContributor: {
            contributor: {
              image: {
                thumb: {
                  png: {
                    url: be_present,
                  }
                }
              }
            },

            errors: be_blank,

            attributeErrors: be_blank,
          }
        }
      end

      it "creates an organization contributor with an image" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Contributor, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
