# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class Contributors < Base
        include Schemas::Properties::References::Collected

        model_type! ::Contributor
      end
    end
  end
end
