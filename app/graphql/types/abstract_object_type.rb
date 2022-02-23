# frozen_string_literal: true

module Types
  # @abstract
  class AbstractObjectType < GraphQL::Schema::Object
    include Graphql::ImageAttachmentSupport
    include Graphql::PunditHelpers

    HAS_ADMIN_ACCESS = ->(obj, args = {}, ctx = {}) { ctx[:current_user]&.has_global_admin_access? }
  end
end
