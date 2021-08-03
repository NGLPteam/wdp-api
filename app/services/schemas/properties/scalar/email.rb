# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Email < Base
        attribute :default, :string

        schema_type! :string

        config.schema_predicates = {
          format?: AppTypes::EMAIL_PATTERN
        }
      end
    end
  end
end
