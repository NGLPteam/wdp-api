# frozen_string_literal: true

module Entities
  # Render all layouts for an {HierarchicalEntity entity}.
  class LayoutsRenderer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :entity, Entities::Types::Entity
    end

    standard_execution!

    def call
      run_callbacks :execute do
        yield render_each!
      end

      Success entity
    end

    wrapped_hook! def render_each
      Layout.each do |layout|
        yield entity.render_layout(layout.kind)
      end

      super
    end
  end
end
