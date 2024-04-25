# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      # @note `extend` this on `Types::BaseInterface`.
      module Interface
        class << self
          def extended(base)
            base.include GraphQL::Schema::Interface
            base.include Support::GraphQLAPI::ImageAttachmentSupport
            base.include Support::GraphQLAPI::PunditHelpers
            base.extend Support::GraphQLAPI::Enhancements::Interface::Composable
          end
        end

        module ClassMethods
          def implements(interface)
            include interface

            mod = ComposedInterface.new(interface:)

            singleton_class.prepend mod
          end
        end

        module Composable
          def included(base)
            super if defined?(super)

            base.extend Support::GraphQLAPI::Enhancements::Interface::ClassMethods if base.kind_of?(Module)
            base.extend Support::GraphQLAPI::ImageAttachmentSupport::ClassMethods
          end
        end

        # @api private
        class ComposedInterface < Module
          # @param [Module] interface
          def initialize(interface:)
            @interface = interface

            # :nocov:
            raise TypeError, "must be a GraphQL interface: #{interface}" unless interface.include? GraphQL::Schema::Interface
            # :nocov:

            define_method(:included) do |child_class|
              super(child_class) if defined?(super) && !child_class.include?(::Types::BaseInterface)

              child_class.implements interface if child_class < GraphQL::Schema::Object || child_class.include?(::Types::BaseInterface)
            end
          end

          # @api private
          # @return [String]
          def inspect
            # :nocov:
            "Support::GraphQLAPI::Enhancements::Interface::ComposedModule(#{@interface.name})"
            # :nocov:
          end
        end
      end
    end
  end
end
