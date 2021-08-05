# frozen_string_literal: true

module Schemas
  module Orderings
    class FilterDefinition
      include StoreModel::Model

      attribute :schemas, :string_array, default: proc { [] }
    end
  end
end
