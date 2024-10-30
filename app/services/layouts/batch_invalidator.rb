# frozen_string_literal: true

module Layouts
  # Invalidate all {LayoutInstance}s owned by provided {LayoutDefinition}s.
  #
  # @see Layouts::InvalidateBatch
  class BatchInvalidator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :layout_definitions, ::Layouts::Types::LayoutDefinitions, default: proc { ::Layouts::Types::EMPTY_ARRAY }
    end

    standard_execution!

    # @return [Integer]
    attr_reader :invalidated_count

    # @return [<Layout>]
    attr_reader :layouts

    # @return [String, nil]
    attr_reader :query

    # @return [Dry::Monads::Success(Integer)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield mark_stale!
      end

      Success invalidated_count
    end

    wrapped_hook! def prepare
      @invalidated_count = 0

      @layouts = layout_definitions.map { _1.layout_record }.uniq

      @query = build_query

      super
    end

    wrapped_hook! def mark_stale
      @invalidated_count = layouts.present? ? LayoutInvalidation.connection.exec_update(query, "Layout Invalidation") : 0

      super
    end

    private

    # @return [String, nil]
    def build_query
      return if layouts.blank?

      union = build_projected_union

      <<~SQL
      WITH layout_entities AS (
        #{union}
      )
      INSERT INTO layout_invalidations(entity_type, entity_id)
      SELECT entity_type, entity_id FROM layout_entities;
      SQL
    end

    def build_projected_union
      layouts.map do |layout|
        layout
          .instance_klass
          .limited_to_layout_definitions(*layout_definitions)
          .select(:entity_type, :entity_id)
          .to_sql
      end.join("\nUNION\n")
    end
  end
end
