# frozen_string_literal: true

module Types
  class SchemaDefinitionType < Types::AbstractModel
    field :kind, Types::SchemaKindType, null: false
    field :identifier, String, null: false
    field :name, String, null: false
    field :namespace, String, null: false

    def slug
      object.system_slug
    end
  end
end
