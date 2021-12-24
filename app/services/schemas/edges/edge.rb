# frozen_string_literal: true

module Schemas
  module Edges
    # An edge describes a connection between a parent and child {HierarchicalEntity entity},
    # what methods connect the two, etc.
    class Edge < Dry::Struct
      attribute :parent, Schemas::Types::Kind
      attribute :child, Schemas::Types::Kind

      attribute :associations do
        attribute :parent, Schemas::Types::ParentAssociation
        attribute :child, Schemas::Types::ChildAssociation
        attribute :inherit, Schemas::Types::ParentInheritableAssociation.optional
        attribute :nullify, Schemas::Types::NullifiableAssociation.optional

        def has_inherited_association?
          inherit.present?
        end

        def has_nullified_association?
          nullify.present?
        end
      end

      attribute :roles do
        attribute :create_children, Schemas::Types::Symbol.enum(:create_items?, :create_collections?)
      end

      delegate :has_inherited_association?, :has_nullified_association?, to: :associations

      def tree?
        parent == child
      end
    end
  end
end
