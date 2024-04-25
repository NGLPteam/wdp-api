# frozen_string_literal: true

module Support
  module DryMutations
    module Types
      include Dry.Types

      AttributePath = Array.of(Integer | Coercible::String)
    end
  end
end
