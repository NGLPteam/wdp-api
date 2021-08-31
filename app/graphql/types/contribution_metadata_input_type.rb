# frozen_string_literal: true

module Types
  class ContributionMetadataInputType < Types::BaseInputObject
    description "An input type that builds contribution metadata"

    argument :title, String, required: false, attribute: true, description: "A value that can override a contribution's contributor's title"
    argument :affiliation, String, required: false, attribute: true, description: "A value that can override a contribution's contributor's affiliation"
    argument :display_name, String, required: false, attribute: true, description: "A value that can override a contribution's contributor's displayed name"
    argument :location, String, required: false, attribute: true, description: "A value that can override a contribution's contributor's location"

    def prepare
      to_h
    end
  end
end
