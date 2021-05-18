module HasSchemaDefinition
  extend ActiveSupport::Concern

  included do
    belongs_to :schema_definition
  end
end
