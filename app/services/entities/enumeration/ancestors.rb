# frozen_string_literal: true

module Entities
  module Enumeration
    # Enumerate all ancestors of an entity in a non-deterministic order.
    class Ancestors < Abstract
      def build_hierarchical_scope
        super.containing(entity)
      end

      def each
        ::Entity.containing(entity).includes(:hierarchical).find_each(start: cursor) do |subentity|
          yield subentity.hierarchical, subentity.id
        end
      end
    end
  end
end
