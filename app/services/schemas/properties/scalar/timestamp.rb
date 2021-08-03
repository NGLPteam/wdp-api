# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Timestamp < Base
        schema_type! :time
      end
    end
  end
end
