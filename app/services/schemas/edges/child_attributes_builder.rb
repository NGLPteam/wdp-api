# frozen_string_literal: true

module Schemas
  module Edges
    class ChildAttributesBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :parent, Schemas::Types::SchemaInstance
        param :edge, Schemas::Edges::Edge
      end

      # @return [Hash]
      def call
        {}.tap do |at|
          at[edge.associations.parent] = parent

          if edge.has_inherited_association?
            edge.associations.inherit.tap do |inherited|
              at[inherited] = parent.public_send inherited
            end
          end

          at[edge.associations.nullify] = nil if edge.has_nullified_association?
        end
      end
    end
  end
end
