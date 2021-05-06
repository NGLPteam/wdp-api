# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    include Graphql::OperationHelpers
    include Graphql::PunditHelpers

    edge_type_class Types::BaseEdge

    connection_type_class Types::BaseConnection

    field_class Types::BaseField

    HAS_ADMIN_ACCESS = ->(obj, args = {}, ctx = {}) { ctx[:current_user]&.has_global_admin_access? }
  end
end
