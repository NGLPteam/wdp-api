# frozen_string_literal: true

# A view that wraps around {Entity} and {SchemaVersion} to present values
# for sorting and upserting into {OrderingEntry}.
#
# @see Schemas::Orderings::Refresh
# rubocop:disable Metrics/AbcSize
class OrderingEntryCandidate < ApplicationRecord
  include View

  belongs_to :entity, polymorphic: true
  belongs_to :schema_version

  scope :filtered_by_schema_version, ->(schemas) { where(schema_version: SchemaVersion.filtered_by(schemas)) }

  class << self
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def query_for(ordering)
      entity = ordering.entity

      order_statements = Schemas::Orderings::OrderBuilder.(ordering.order_definitions)

      ordering_id_expr = arel_quote(ordering.id).as("ordering_id")

      window = Arel::Nodes::Window.new.order(*order_statements)

      position_expr = arel_named_fn("row_number").over(window).as("position")

      relative_depth_expr = (arel_table[:entity_depth] - arel_quote(entity.hierarchical_depth)).as("relative_depth")

      query = select(
        ordering_id_expr,
        arel_table[:entity_id],
        arel_table[:entity_type],
        position_expr,
        arel_table[:link_operator],
        arel_table[:auth_path],
        arel_table[:scope],
        relative_depth_expr
      ).reorder(*order_statements)

      query = query.filtered_by_schema_version(ordering.filter_schemas) if ordering.filter_schemas.present?

      query = query.with_link_selector_for(ordering)

      query = query.with_child_selector_for(ordering)

      return query
    end

    # @api private
    def with_child_selector_for(ordering)
      selection = ordering.definition.select

      auth_path = arel_table[:auth_path]

      raw_query = selection.build_auth_query_for(ordering.entity.auth_path)

      auth_query = arel_cast(arel_quote(raw_query), "lquery")

      expr = arel_infix ?~, auth_path, auth_query

      where(expr)
    end

    # @api private
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
  end
end
# rubocop:enable Metrics/AbcSize
