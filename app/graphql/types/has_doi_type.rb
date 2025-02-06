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

    field :doi_data, ::Types::DOIDataType, null: false do
      description <<~TEXT
      The data sanitized from `rawDOI`, including things like the URL and host.
      TEXT
    end

    field :has_weird_doi, Boolean, null: false do
      description <<~TEXT
      For use in the admin, something to signify that data has been set on `rawDOI`
      that could not be properly assigned to `doi`.
      TEXT
    end

    field :raw_doi, String, null: true do
      description <<~TEXT
      The value that was set on the entity. It will be validated and sanitized
      and be set on `doi` if possible.
      TEXT
    end
  end
end
