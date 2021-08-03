# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Contributors < Base
        include CollectedReference

        model_type! ::Contributor
      end
    end
  end
end
