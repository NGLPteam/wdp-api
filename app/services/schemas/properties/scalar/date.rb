# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Date < Base
        schema_type! :date

        config.graphql_value_key = :date
      end
    end
  end
end
