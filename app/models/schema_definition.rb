# frozen_string_literal: true

class SchemaDefinition < ApplicationRecord
  include HasSystemSlug

  pg_enum! :kind, as: "schema_kind"

  validates :name, :identifier, :kind, presence: true
end
