# frozen_string_literal: true

module Schemas
  module Properties
    module Types
      include Dry.Types

      GroupOrScalar = Instance(Schemas::Properties::Scalar::Base) | Instance(Schemas::Properties::GroupDefinition)

      List = Array.of(GroupOrScalar)
    end
  end
end
