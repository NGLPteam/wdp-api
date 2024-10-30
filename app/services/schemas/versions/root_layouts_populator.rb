# frozen_string_literal: true

module Schemas
  module Versions
    # @see Schemas::Versions::PopulateRootLayouts
    class RootLayoutsPopulator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :schema_version, Schemas::Types::Version

        option :skip_layout_invalidation, ::Schemas::Types::Bool, default: proc { false }
      end

      standard_execution!

      # @return [<LayoutDefinition>]
      attr_reader :layout_definitions

      # @return [Dry::Monads::Success<LayoutDefinition>]
      def call
        run_callbacks :execute do
          yield build_each_root!
        end

        schema_version.reload

        Success layout_definitions
      end

      wrapped_hook! def build_each_root
        @layout_definitions = []

        Layout.each do |layout|
          definition = yield build_root_for layout.kind

          layout_definitions << definition
        end

        super
      end

      private

      # @param [Layouts::Types::Kind] layout_kind
      # @return [Dry::Monads::Success(LayoutDefinition)]
      do_for! def build_root_for(layout_kind)
        layout_config = schema_version.root_layout_config_for(layout_kind)

        layout_definition = yield layout_config.apply_to(schema_version, entity: nil, skip_layout_invalidation:)

        Success layout_definition
      end
    end
  end
end
