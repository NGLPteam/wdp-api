# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class ControlledVocabulary < Base
        include Schemas::Properties::References::Scalar
        include Schemas::Properties::References::ControlledVocabulary
        include Schemas::Properties::Scalar::ForcesOptional
      end
    end
  end
end
