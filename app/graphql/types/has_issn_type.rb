# frozen_string_literal: true

module Types
  module HasISSNType
    include Types::BaseInterface

    description "An entity that has an ISSN"

    field :issn, String, null: true do
      description <<~TEXT
      The International Standard Serial Number for this entity. See https://issn.org
      TEXT
    end
  end
end
