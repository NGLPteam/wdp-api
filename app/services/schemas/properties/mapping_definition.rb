# frozen_string_literal: true

module Schemas
  module Properties
    # @todo Not used yet, schema subject to change
    class MappingDefinition
      include StoreModel::Model

      attribute :standard, :string
      attribute :entity, :string
      attribute :path, :string
    end
  end
end
