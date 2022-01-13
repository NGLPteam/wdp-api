# frozen_string_literal: true

module Types
  module BaseInterface
    include GraphQL::Schema::Interface
    include Graphql::ImageAttachmentSupport
    include Graphql::PunditHelpers

    edge_type_class Types::BaseEdge
    connection_type_class Types::BaseConnection

    field_class Types::BaseField

    class ComposedInterface < Module
      def initialize(interface:)
        @interface = interface

        # :nocov:

        raise TypeError, "must be a GraphQL interface: #{interface}" unless interface.include? GraphQL::Schema::Interface

        # :nocov:

        define_method(:included) do |child_class|
          super(child_class) if defined?(super) && !child_class.include?(Types::BaseInterface)

          child_class.implements interface if child_class < GraphQL::Schema::Object || child_class.include?(Types::BaseInterface)
        end
      end

      def inspect
        "Types::BaseInterface::ComposedModule(#{@interface.name})"
      end
    end

    module ClassMethods
      def implements(interface)
        include interface

        mod = ComposedInterface.new interface: interface

        singleton_class.prepend mod
      end
    end

    class << self
      def included(base)
        super if defined?(super)

        base.extend Types::BaseInterface::ClassMethods if base.kind_of?(Module)
        base.extend Graphql::ImageAttachmentSupport::ClassMethods
      end
    end
  end
end
