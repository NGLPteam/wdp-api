# frozen_string_literal: true

module Types
  class ContributionMetadataType < Types::BaseObject
    description "Metadata for a contribution"

    field :role, String, null: true, description: "An arbitrary field describing how the contributor contributed"
    field :title, String, null: true, description: "A value that can override a contribution's contributor's title"
    field :affiliation, String, null: true, description: "A value that can override a contribution's contributor's affiliation"
    field :display_name, String, null: true, description: "A value that can oerride a contribution's contributor's displayed name"
  end
end
