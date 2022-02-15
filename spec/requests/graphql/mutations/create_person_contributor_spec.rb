# frozen_string_literal: true

RSpec.describe Mutations::CreatePersonContributor, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation createPersonContributor($input: CreatePersonContributorInput!) {
    createPersonContributor(input: $input) {
      contributor {
        kind
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

    # person-specific properties
    let_mutation_input!(:given_name) { Faker::Name.first_name }
    let_mutation_input!(:family_name) { Faker::Name.last_name }
    let_mutation_input!(:title) { Faker::Name.prefix }
    let_mutation_input!(:affiliation) { Faker::Company.name }

    let!(:expected_shape) do
      gql.mutation :create_person_contributor do |m|
        m.prop :contributor do |c|
          c[:kind] = "person"
        end
      end
    end

    it "creates a person contributor" do
      expect_the_default_request.to change(Contributor, :count).by(1)

      expect_graphql_data expected_shape
    end

    context "with an invalid link" do
      let(:links) do
        [{ title: "Some Link", url: "bad://link" }]
      end

      let!(:expected_shape) do
        gql.mutation :create_person_contributor, no_errors: false do |m|
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

    context "with an already existing ORCID" do
      let(:orcid_value) { SecureRandom.uuid }

      let_mutation_input!(:orcid) { orcid_value }

      let!(:existing_contributor) { FactoryBot.create :contributor, :person, orcid: orcid_value }

      let!(:expected_shape) do
        gql.mutation(:create_person_contributor, no_errors: false) do |m|
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
