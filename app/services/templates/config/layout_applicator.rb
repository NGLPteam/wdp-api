# frozen_string_literal: true

module Templates
  module Config
    # @see Templates::Config::ApplyLayout
    class LayoutApplicator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :layout_config, ::Templates::Types.Instance(::Templates::Config::Utility::AbstractLayout)
        param :schema_version, ::Templates::Types::SchemaVersion

        option :entity, ::Templates::Types::Entity.optional, optional: true

        option :skip_layout_invalidation, ::Templates::Types::Bool, default: proc { false }
      end

      delegate :layout_record, to: :layout_config

      delegate :definition_klass, to: :layout_record, prefix: :layout

      standard_execution!

      # @return [LayoutDefinition]
      attr_reader :layout_definition

      # @return [Boolean]
      attr_reader :root

      alias root? root

      # @return [<TemplateDefinition>]
      attr_reader :template_definitions

      # @return [{ Templates::Types::Kind => <Integer> }]
      attr_reader :template_positions

      # @return [<TemplateDefinition>]
      attr_reader :orphaned_template_definitions

      # @return [Dry::Monads::Success(LayoutDefinition)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield persist_layout_definition!

          yield apply_templates!

          yield find_orphaned_templates!

          yield prune_orphaned_templates!

          yield invalidate_layout_instances!
        end

        Success layout_definition
      end

      wrapped_hook! def prepare
        @root = entity.blank?

        @layout_definition = layout_definition_klass.where(schema_version:, entity:).first_or_initialize

        @template_definitions = []

        @template_positions = build_positions

        @orphaned_template_definitions = []

        super
      end

      wrapped_hook! def persist_layout_definition
        layout_definition.save!

        super
      end

      wrapped_hook! def apply_templates
        layout_config.templates.each do |template_config|
          template_definition = yield template_config.apply_to(layout_definition)

          template_definitions << template_definition

          template_positions[template_definition.template_kind] << template_definition.position
        end

        super
      end

      wrapped_hook! def find_orphaned_templates
        template_positions.each_with_object(orphaned_template_definitions) do |(template_kind, positions), orphans|
          template = ::Template.find(template_kind)

          template => { definition_klass:, }

          definition_scope = definition_klass.where(layout_definition:).sans_positions(positions)

          orphans.concat(definition_scope.to_a)
        end

        super
      end

      wrapped_hook! def prune_orphaned_templates
        orphaned_template_definitions.each do |definition|
          definition.destroy!
        end

        super
      end

      wrapped_hook! def invalidate_layout_instances
        return super if skip_layout_invalidation

        yield layout_definition.invalidate_instances

        super
      end

      private

      # @return [{ Templates::Types::Kind => <Integer> }]
      def build_positions
        layout_record.template_kinds.index_with { [] }
      end
    end
  end
end
