# frozen_string_literal: true

module FiltersBySchemaDefinition
  extend ActiveSupport::Concern

  module ClassMethods
    # @return [ActiveRecord::Relation]
    def filtered_by_schema_definition(*schemas)
      where(schema_definition: SchemaDefinition.filtered_by(*schemas))
    end
  end
end
