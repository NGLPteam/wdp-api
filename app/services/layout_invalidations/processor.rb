# frozen_string_literal: true

module LayoutInvalidations
  # Given a {LayoutInvalidation}, grab its entity and re-render its layouts.
  #
  # @see Rendering::ProcessLayoutInvalidationsJob
  class Processor < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :layout_invalidation, Types::LayoutInvalidation
    end

    standard_execution!

    delegate :id, :entity_id, :entity_type, :stale_at, to: :layout_invalidation

    # @return [HierarchicalEntity, nil]
    attr_reader :entity

    def call
      run_callbacks :execute do
        yield prepare!

        yield maybe_render!

        yield prune!
      end

      Success()
    end

    wrapped_hook! def prepare
      @entity = layout_invalidation.reload_entity

      super
    end

    wrapped_hook! def maybe_render
      # It's possible an entity has been deleted before we processed this.
      yield entity.render_layouts if entity.present?

      super
    end

    wrapped_hook! def prune
      LayoutInvalidation.where(entity_id:, entity_type:).stale_before(stale_at).delete_all

      LayoutInvalidation.delete(id)

      super
    end
  end
end
