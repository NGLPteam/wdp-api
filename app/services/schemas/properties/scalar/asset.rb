# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Asset < Base
        include ScalarReference

        model_type! ::Asset
      end
    end
  end
end
