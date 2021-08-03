# frozen_string_literal: true

module Schemas
  module Properties
    # A union type that dispatches between {Schemas::Properties::GroupDefinition groups}
    # and {Schemas::Properties::ScalarDefinition scalars}.
    #
    # @see Schemas::Properties::GroupDefinition
    # @see Schemas::Properties::ScalarDefinition
    Definition = StoreModel.one_of do |json|
      type = json.fetch(:type, json["type"])

      type == "group" ? GroupDefinition : ScalarDefinition.block.call(json)
    end
  end
end
