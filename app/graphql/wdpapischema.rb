# frozen_string_literal: true

class WDPAPISchema < GraphQL::Schema
  mutation Types::MutationType

  query Types::QueryType

  use GraphQL::Batch

  use GraphQL::Guard.new(
    policy_object: GraphqlPolicy,
    not_authorized: ->(type, field) do
      GraphQL::ExecutionError.new("Not authorized to access #{type}.#{field}")
    end
  )

  default_max_page_size Graphql::Constants::MAX_PER_PAGE_SIZE

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
  end

  orphan_types Types::ContributorType, Types::OrganizationContributorType, Types::PersonContributorType

  class << self
    def id_from_object(object, type_definition, query_ctx)
      WDPAPI::Container["relay_node.id_from_object"].call(object, type_definition: type_definition, query_context: query_ctx) do |m|
        m.success do |id|
          id
        end

        m.failure do
          GraphQL::ExecutionError.new("Cannot derive ID")
        end
      end
    end

    def object_from_id(id, query_ctx)
      WDPAPI::Container["relay_node.object_from_id"].call(id, query_context: query_ctx) do |m|
        m.success do |object|
          object
        end

        m.failure do
          GraphQL::ExecutionError.new("Cannot find id for #{id.inspect}")
        end
      end
    end

    def resolve_type(abstract_type, object, context)
      # Remap arg order because we really mainly care about object
      WDPAPI::Container["relay_node.resolve_type"].call(object, abstract_type, context).value_or do |reason|
        opts = {
          extensions: { abstract_type: abstract_type&.graphql_name }
        }

        case reason
        when GraphQL::ExecutionError then reason
        when String then GraphQL::ExecutionError.new(reason, opts)
        else
          GraphQL::ExecutionError.new("Unexpected object: #{object.inspect}", opts)
        end
      end
    end
  end
end
