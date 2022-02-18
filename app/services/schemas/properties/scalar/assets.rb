# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Assets < Base
        include Schemas::Properties::References::Collected

        model_type! ::Asset
      end
    end
  end
end
