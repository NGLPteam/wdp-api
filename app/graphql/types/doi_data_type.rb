# frozen_string_literal: true

module Types
  class DOIDataType < Types::BaseObject
    description <<~TEXT
    Validated and sanitized DOI information for an entity.
    TEXT

    field :doi, String, null: true do
      description <<~TEXT
      A pristine, validated DOI value, absent any URL information.
      TEXT
    end

    field :host, String, null: true do
      description <<~TEXT
      The host that this DOI uses. Will be `"doi.org"` in most cases.
      TEXT
    end

    field :ok, Boolean, null: false do
      description <<~TEXT
      Whether the DOI is ok and valid.
      TEXT
    end

    field :url, String, null: true do
      description <<~TEXT
      The full URL for the DOI.
      TEXT
    end
  end
end
