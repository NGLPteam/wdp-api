# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Timestamp < Base
        schema_type! :time

        config.graphql_value_key = :timestamp
      end
    end
  end
end
