# frozen_string_literal: true

module Entities
  module Enumeration
    # Enumerate all descendants of an entity (including links)
    # in a non-deterministic order.
    class Descendants < Abstract
      def build_hierarchical_scope
        super.descending_from(entity)
      end
    end
  end
end
