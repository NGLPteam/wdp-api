# frozen_string_literal: true

module Types
  class PersonContributorType < Types::AbstractModel
    implements Types::ContributorType

    description "A person that has made contributions"

    field :given_name, String, null: true
    field :family_name, String, null: true
    field :title, String, null: true
    field :affiliation, String, null: true

    def given_name
      object.properties&.person&.given_name
    end

    def family_name
      object.properties&.person&.family_name
    end

    def title
      object.properties&.person&.title
    end

    def affiliation
      object.properties&.person&.affiliation
    end
  end
end
