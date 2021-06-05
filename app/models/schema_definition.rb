# frozen_string_literal: true

class SchemaDefinition < ApplicationRecord
  include HasSystemSlug

  pg_enum! :kind, as: "schema_kind"

  validates :name, :identifier, :kind, presence: true

  class << self
    def default_collection
      @default_collection ||= collection.first || FactoryBot.create(:schema_definition, :collection)
    end

    def default_item
      @default_item ||= item.first || FactoryBot.create(:schema_definition, :item)
    end

    def default_metadata
      @default_metadata ||= metadata.first || FactoryBot.create(:schema_definition, :metadata)
    end
  end
end
