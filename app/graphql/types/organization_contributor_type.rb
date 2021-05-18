# frozen_string_literal: true

module Types
  class OrganizationContributorType < Types::AbstractModel
    implements Types::ContributorType

    description "An organization that has made contributions"

    field :legal_name, String, null: true
    field :location, String, null: true

    def legal_name
      object.properties&.organization&.legal_name
    end

    def location
      object.properties&.organization&.location
    end
  end
end
