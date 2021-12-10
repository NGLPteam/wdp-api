# frozen_string_literal: true

module Types
  module HasDOIType
    include Types::BaseInterface

    description "An entity that has a DOI"

    field :doi, String, null: true do
      description <<~TEXT
      The Digital Object Identifier for this entity. See https://doi.org
      TEXT
    end
  end
end
