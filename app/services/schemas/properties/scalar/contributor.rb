# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Contributor < Base
        include ScalarReference

        model_type! ::Contributor
      end
    end
  end
end
