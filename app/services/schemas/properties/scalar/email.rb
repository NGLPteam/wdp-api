# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Email < Base
        attribute :default, :string

        orderable!

        schema_type! :string

        config.schema_predicates = {
          format?: AppTypes::EMAIL_PATTERN
        }

        config.graphql_value_key = :address
      end
    end
  end
end
