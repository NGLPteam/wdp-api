# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      # A single reference to {HierarchicalEntity an entity}.
      #
      # @see EntityReference
      class Entity < Base
        include Schemas::Properties::References::Scalar
        include Schemas::Properties::References::Entity
      end
    end
  end
end
