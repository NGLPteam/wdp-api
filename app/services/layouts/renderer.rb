# frozen_string_literal: true

module Layouts
  # Render an {HierarchicalEntity entity} for a {LayoutDefinition}.
  class Renderer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :layout_definition, Layouts::Types::LayoutDefinition

      param :entity, Layouts::Types::Entity
    end

    standard_execution!

    delegate :layout_kind, to: :layout_definition

    # @return [String]
    attr_reader :generation

    # @return [Layout]
    attr_reader :layout

    # @return [LayoutInstance]
    attr_reader :layout_instance

    def call
      run_callbacks :execute do
        yield prepare!

        yield persist_instance!

        yield render_each_template!

        yield upsert_digests!
      end

      Success entity
    end

    wrapped_hook! def prepare
      @generation = SecureRandom.uuid

      @layout = Layout.find layout_kind

      @layout_instance = layout.instance_klass.fetch_for(entity, layout_definition:)

      super
    end

    wrapped_hook! def persist_instance
      layout_instance.layout_definition = layout_definition
      layout_instance.generation = generation

      layout_instance.save!

      super
    end

    wrapped_hook! def render_each_template
      layout_definition.template_definitions.each do |template_definition|
        yield template_definition.render(layout_instance, generation:)
      end
    end

    around_render_each_template :track_render!

    wrapped_hook! def upsert_digests
      yield layout_instance.upsert_template_instance_digests

      super
    end

    private

    # @return [void]
    def track_render!
      layout_instance.track_render! do
        yield
      end
    end
  end
end
