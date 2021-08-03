# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Assets < Base
        include CollectedReference

        model_type! ::Asset
      end
    end
  end
end
