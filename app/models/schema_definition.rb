# frozen_string_literal: true

class SchemaDefinition < ApplicationRecord
  include HasSystemSlug

  pg_enum! :kind, as: "schema_kind"

  validates :name, :identifier, :kind, presence: true

  class << self
    def default_collection
      return FactoryBot.create(:schema_definition, :collection) if Rails.env.test?

      # :nocov:
      @default_collection ||= collection.first || FactoryBot.create(:schema_definition, :collection)
      # :nocov:
    end

    def default_item
      return FactoryBot.create(:schema_definition, :item) if Rails.env.test?

      # :nocov:
      @default_item ||= item.first || FactoryBot.create(:schema_definition, :item)
      # :nocov:
    end

    def default_metadata
      return FactoryBot.create(:schema_definition, :metadata) if Rails.env.test?

      # :nocov:
      @default_metadata ||= metadata.first || FactoryBot.create(:schema_definition, :metadata)
      # :nocov:
    end
  end
end
