# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Boolean < Base
        attribute :default, :boolean

        orderable!

        searchable!

        schema_type! :bool

        config.graphql_value_key = :checked
      end
    end
  end
end
