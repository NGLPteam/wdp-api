# frozen_string_literal: true

module Layouts
  module Definitions
    # Generate {LayoutInvalidation} for all active {LayoutInstance}s
    # in the provided {LayoutDefinition}.
    #
    # @see Layouts::Definitions::Invalidate
    class Invalidator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :layout_definition, ::Layouts::Types::LayoutDefinition
      end

      standard_execution!

      # @return [Integer]
      attr_reader :invalidated_count

      # @return [String]
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

        super
      end

      wrapped_hook! def mark_stale
        @invalidated_count = LayoutInvalidation.connection.exec_update(query, "Layout Invalidation")

        super
      end

      private

      # @return [String]
      def build_query
        projection = layout_definition.layout_instances.select(:entity_type, :entity_id).to_sql

        <<~SQL
        INSERT INTO layout_invalidations (entity_type, entity_id)
        #{projection}
        SQL
      end
    end
  end
end
