# frozen_string_literal: true

module Layouts
  # Invalidate all {LayoutInstance}s owned by root {LayoutDefinition}s.
  #
  # @see Layouts::InvalidateRoots
  class RootsInvalidator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :layouts, ::Layouts::Types::LayoutRecords, default: proc { ::Layout.all.to_a }
    end

    standard_execution!

    # @return [Integer]
    attr_reader :invalidated_count

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

      @query = build_query

      return Failure[:no_layouts, "No layouts provided"] if layouts.blank?

      super
    end

    wrapped_hook! def mark_stale
      @invalidated_count = LayoutInvalidation.connection.exec_update(query, "Layout Invalidation")

      super
    end

    private

    # @return [String, nil]
    def build_query
      return if layouts.blank?

      union = build_projected_union

      <<~SQL
      WITH root_layout_entities AS (
        #{union}
      )
      INSERT INTO layout_invalidations(entity_type, entity_id)
      SELECT entity_type, entity_id FROM root_layout_entities;
      SQL
    end

    def build_projected_union
      layouts.map do |layout|
        layout
          .instance_klass
          .root
          .select(:entity_type, :entity_id)
          .to_sql
      end.join("\nUNION\n")
    end
  end
end
