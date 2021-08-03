# frozen_string_literal: true

module Types
  class SchemaVersionOrderType < Types::BaseEnum
    description "Order schema versions by various factors"

    value "LATEST", description: "Order with newest versions at the top"
    value "OLDEST", description: "Order with oldest versions at the top"
  end
end
