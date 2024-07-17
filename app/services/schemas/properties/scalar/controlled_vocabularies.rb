# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class ControlledVocabularies < Base
        include Schemas::Properties::References::Collected
        include Schemas::Properties::References::ControlledVocabulary
        include Schemas::Properties::Scalar::ForcesOptional
      end
    end
  end
end
