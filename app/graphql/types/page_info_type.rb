# frozen_string_literal: true

module Types
  class PageInfoType < Types::AbstractObjectType
    include GraphQL::Types::Relay::PageInfoBehaviors

    field :page, Integer, null: true do
      description "The page (if page-based pagination is supported and one was provided, does not introspect a value with cursor-based pagination)"
    end

    field :page_count, Integer, null: true do
      description "The total number of pages available to the connection (if page-based pagination supported and a page was provided)"
    end

    field :per_page, Integer, null: true do
      description "The number of edges/nodes per page (if page-based pagination supported and a page was provided)"
    end

    field :total_count, Integer, null: false do
      description "The total number of nodes available to this connection, constrained by applied filters (if any)"
    end

    field :total_unfiltered_count, Integer, null: false do
      description "The total number of nodes available to this connection, independent of any filters"
    end

    # @return [Integer, nil]
    def page
      object.arguments[:page]
    end

    # @return [Integer, nil]
    def page_count
      return nil if per_page.nil?

      size = object.items.size

      return 0 if size.zero?

      full_pages, rem = size.divmod per_page

      rem > 0 ? full_pages + 1 : full_pages
    end

    # @return [Integer, nil]
    def per_page
      object.arguments[:per_page] if page.present?
    end

    # @return [Integer]
    def total_count
      object.items.size
    end

    # @return [Integer]
    def total_unfiltered_count
      case object.items
      when Array then object.items.size
      when ActiveRecord::Relation
        # TODO: Use a GraphQL-batch loader for this
        Pundit.policy_scope(context[:current_user], object.items.model).count
      else
        object.items.size
      end
    end
  end
end
