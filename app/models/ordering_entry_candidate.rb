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

  # Calculate one-time stats that are used for {SCORED_CANDIDATES_QUERY}.
  TREE_STATS_QUERY = <<~SQL
  SELECT
    text2ltree(%1$s) AS parent_path,
    COUNT(*) FILTER (WHERE auth_path <> %1$s) AS total_descendants,
    MAX(nlevel(auth_path) - nlevel(text2ltree(%1$s))) AS max_depth
  FROM ordering_entry_candidates
  WHERE
    auth_path <@ text2ltree(%1$s)
  SQL

  # Recalculate ordering positions based on relative depth and
  # ancestral scores.
  SCORED_CANDIDATES_QUERY = <<~SQL
  SELECT fc.entity_id, fc.entity_type,
    SUM(
      (1 + anc.position)
      *
      (
        stats.total_descendants
        ^
        (
          stats.max_depth + 1 - depths.generations
        )
      )
    )::bigint AS position,
    SUM(
      (1 + anc.inverse_position)
      *
      (
        stats.total_descendants
        ^
        (
          stats.max_depth + 1 - depths.generations
        )
      )
    )::bigint AS inverse_position,
    COUNT(DISTINCT anc.auth_path) AS tree_depth
    FROM flat_candidates fc
    CROSS JOIN stats
    INNER JOIN flat_candidates AS anc ON
      anc.auth_path @> fc.auth_path
    LEFT JOIN LATERAL (
      SELECT nlevel(anc.auth_path) - nlevel(stats.parent_path) AS generations
    ) AS depths ON true
    GROUP BY fc.entity_id, fc.entity_type
  SQL

  # For finalizing the tree-ordered {.query_for} by combining the recalculated
  # positions in {SCORED_CANDIDATES_QUERY} with the otherwise static values
  # in the original generated query.
  REMAPPED_CANDIDATES_QUERY = <<~SQL
  SELECT
    fc.ordering_id,
    entity_id,
    entity_type,
    sc.position AS position,
    sc.inverse_position AS inverse_position,
    fc.link_operator,
    fc.auth_path,
    fc.scope,
    fc.relative_depth,
    sc.tree_depth,
    td.tree_parent_id,
    td.tree_parent_type
  FROM flat_candidates AS fc
  INNER JOIN scored_candidates AS sc USING (entity_id, entity_type)
  LEFT JOIN LATERAL (
    SELECT DISTINCT ON (p.entity_id, p.entity_type)
      p.entity_id AS tree_parent_id, p.entity_type AS tree_parent_type
    FROM scored_candidates AS p
    INNER JOIN flat_candidates x ON p.entity_id = x.entity_id AND p.entity_type = x.entity_type
    WHERE
      fc.relative_depth > 1
      AND
      x.auth_path @> fc.auth_path
      AND
      p.tree_depth < sc.tree_depth
    ORDER BY p.entity_id, p.entity_type, p.tree_depth DESC
    LIMIT 1
  ) td ON fc.relative_depth > 1
  SQL

  class << self
    # Build a SQL query that orders a subset of {OrderingEntryCandidate} by whatever
    # an {Ordering} is {Schemas::Orderings::Definition is looking for}.
    #
    # @param [Ordering] ordering
    # @return [ActiveRecord::Relation<OrderingEntryCandidate>]
    def query_for(ordering)
      base_query = build_projection_and_joins_for(ordering).
        with_schema_selector_for(ordering).
        with_child_selector_for(ordering).
        with_link_selector_for(ordering)

      return base_query unless ordering.tree_mode?

      entity = ordering.entity

      stats_query = TREE_STATS_QUERY % connection.quote(entity.auth_path)

      all.with(
        stats: stats_query,
        flat_candidates: base_query,
        scored_candidates: SCORED_CANDIDATES_QUERY,
        remapped_candidates: REMAPPED_CANDIDATES_QUERY
      ).select(
        "ordering_id", "entity_id", "entity_type", "position", "inverse_position", "link_operator", "auth_path", "scope", "relative_depth",
        "tree_depth", "tree_parent_id", "tree_parent_type"
      ).from("remapped_candidates").order(position: :asc)
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

      ordering_id_expr = arel_cast(arel_quote(ordering.id), "uuid").as("ordering_id")

      default_position_expr = arel_windowed_position_for compiled.default_orderings

      inverse_position_expr = arel_windowed_position_for compiled.inverse_orderings

      relative_depth_expr = arel_relative_depth_for(entity)

      query = select(
        ordering_id_expr,
        arel_table[:entity_id],
        arel_table[:entity_type],
        default_position_expr.as("position"),
        inverse_position_expr.as("inverse_position"),
        arel_table[:link_operator],
        arel_table[:auth_path],
        arel_table[:scope],
        relative_depth_expr.as("relative_depth"),
        arel_quote(nil).as("tree_depth"),
        arel_quote(nil).as("tree_parent_id"),
        arel_quote(nil).as("tree_parent_type")
      )

      query.joins!(*compiled.joins.values) if compiled.joins.any?

      query.order! default_position_expr.asc unless ordering.tree_mode?

      return query
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
