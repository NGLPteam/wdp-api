# frozen_string_literal: true

module Schemas
  module Edges
    # A calculator to generate {Schemas::Edges::Edge edges} for use with
    # validations and protecting hierarchical integrity.
    class Calculator
      include Dry::Monads[:result, :try]
      include Dry::Initializer[undefined: false].define -> do
        param :parent, Schemas::Types::Kind
        param :child, Schemas::Types::Kind
      end

      # @param [String] parent
      # @param [String] child
      # @return [Dry::Monads::Success(Schemas::Edges::Edge)]
      # @return [Dry::Monads::Failure(:unacceptable_edge, Schemas::Edges::Invalid)]
      def call
        attributes = default_attributes

        attributes[:associations][:parent] = calculate_parent_association
        attributes[:associations][:child] = calculate_child_association
        attributes[:associations][:inherit] = calculate_inherited
        attributes[:associations][:nullify] = calculate_nullified

        attributes[:roles][:create_children] = :"create_#{child.pluralize}?"

        Try[Dry::Struct::Error] do
          Schemas::Edges::Edge.new attributes
        end.to_result.or do
          Failure[:unacceptable_edge, Schemas::Edges::Invalid.new(attributes)]
        end
      end

      private

      def default_attributes
        { parent: parent, child: child, associations: {}, roles: {} }
      end

      # @return [Symbol]
      def calculate_parent_association
        case [parent, child]
        when %w[community collection] then :community
        when %w[collection collection], %w[item item] then :parent
        when %w[collection item] then :collection
        end
      end

      # @return [Symbol]
      def calculate_child_association
        case [parent, child]
        when %w[community collection] then :collections
        when %w[collection collection], %w[item item] then :children
        when %w[collection item] then :items
        end
      end

      def calculate_inherited
        case [parent, child]
        when %w[collection collection] then :community
        when %w[item item] then :collection
        end
      end

      def calculate_nullified
        case [parent, child]
        when %w[community collection] then :parent
        when %w[collection item] then :parent
        end
      end
    end
  end
end
