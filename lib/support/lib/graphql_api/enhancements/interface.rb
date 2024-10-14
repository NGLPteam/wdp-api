# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Enhancements
      # @note `extend` this on `Types::BaseInterface`.
      module Interface
        class << self
          def extended(base)
            base.include GraphQL::Schema::Interface
            base.include Support::GraphQLAPI::AssociationHelpers
            base.include Support::GraphQLAPI::ImageAttachmentSupport
            base.include Support::GraphQLAPI::PunditHelpers
            base.extend Support::GraphQLAPI::Enhancements::Interface::Composable
          end
        end

        module Composable
          def included(base)
            super if defined?(super)

            base.extend Support::GraphQLAPI::AssociationHelpers::ClassMethods
            base.extend Support::GraphQLAPI::ImageAttachmentSupport::ClassMethods
          end
        end
      end
    end
  end
end
