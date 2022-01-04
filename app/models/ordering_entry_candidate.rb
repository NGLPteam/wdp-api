# frozen_string_literal: true

# A view that wraps around {Entity} and {SchemaVersion} to present values
# for sorting and upserting directly into {OrderingEntry}. Individual
# instances of this model are never used.
#
# @see Schemas::Orderings::Refresh
# rubocop:disable Metrics/AbcSize
class OrderingEntryCandidate < ApplicationRecord
  include View

  belongs_to :entity, polymorphic: true
  belongs_to :schema_version

  class << self
    # Build a SQL query that orders a subset of {OrderingEntryCandidate} by whatever
    # an {Ordering} is {Schemas::Orderings::Definition is looking for}.
    #
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def query_for(ordering)
      build_projection_and_joins_for(ordering).
        with_schema_selector_for(ordering).
        with_child_selector_for(ordering).
        with_link_selector_for(ordering)
    end

    # @api private
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def with_child_selector_for(ordering)
      selection = ordering.definition.select

      auth_path = arel_table[:auth_path]

      raw_query = selection.build_auth_query_for(ordering.entity.auth_path)

      auth_query = arel_cast(arel_quote(raw_query), "lquery")

      expr = arel_infix ?~, auth_path, auth_query

      where(expr)
    end

    # @api private
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def with_link_selector_for(ordering)
      links = ordering.definition.select.links

      if links.none?
        where(link_operator: nil)
      elsif links.any? && !links.all?
        where(link_operator: links.selector)
      else
        all
      end
    end

    # @api private
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def with_schema_selector_for(ordering)
      allowed_schema_versions = ordering.definition.filter.allowed_schema_versions

      if allowed_schema_versions.present?
        where(schema_version: allowed_schema_versions)
      else
        all
      end
    end

    private

    # Starts off the query for {.query_for}
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def build_projection_and_joins_for(ordering)
      entity = ordering.entity

      compiled = ordering.compile_ordering_expression

      ordering_id_expr = arel_quote(ordering.id).as("ordering_id")

      default_position_expr = arel_windowed_position_for compiled.default_orderings

      inverse_position_expr = arel_windowed_position_for compiled.inverse_orderings

      relative_depth_expr = arel_relative_depth_for(entity).as("relative_depth")

      select(
        ordering_id_expr,
        arel_table[:entity_id],
        arel_table[:entity_type],
        default_position_expr.as("position"),
        inverse_position_expr.as("inverse_position"),
        arel_table[:link_operator],
        arel_table[:auth_path],
        arel_table[:scope],
        relative_depth_expr
      ).then do |query|
        if compiled.joins.any?
          query.joins(*compiled.joins.values)
        else
          query
        end
      end
    end

    # @param [HasSchemaDefinition] entity
    # @return [Arel::Nodes::Subtraction(Arel::Attribute, Arel::Nodes::Quoted)]
    def arel_relative_depth_for(entity)
      arel_table[:entity_depth] - arel_quote(entity.hierarchical_depth)
    end

    # @param [<Arel::Nodes::Ordering>] order_statements
    # @return [Arel::Nodes::Over]
    def arel_windowed_position_for(order_statements)
      window = Arel::Nodes::Window.new.order(*order_statements)

      arel_named_fn("row_number").over(window)
    end
  end
end
# rubocop:enable Metrics/AbcSize
