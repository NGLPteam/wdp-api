# frozen_string_literal: true

module Types
  module BaseInterface
    include GraphQL::Schema::Interface
    include Graphql::ImageAttachmentSupport
    include Graphql::PunditHelpers

    edge_type_class Types::BaseEdge
    connection_type_class Types::BaseConnection

    field_class Types::BaseField

    class << self
      def included(base)
        super if defined?(super)

        base.extend Graphql::ImageAttachmentSupport::ClassMethods
      end
    end
  end
end
