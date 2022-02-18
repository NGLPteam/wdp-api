# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      # A deterministically-ordered list of references to {HierarchcialEntity entities}.
      class Entities < Base
        include Schemas::Properties::References::Collected
        include Schemas::Properties::References::Entity
      end
    end
  end
end
