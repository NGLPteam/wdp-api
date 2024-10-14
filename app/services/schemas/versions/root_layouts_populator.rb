# frozen_string_literal: true

module Schemas
  module Versions
    # @see Schemas::Versions::PopulateRootLayouts
    # @todo Read from definition files
    class RootLayoutsPopulator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :schema_version, Schemas::Types::Version
      end

      standard_execution!

      def call
        run_callbacks :execute do
          yield build_each_root!
        end

        schema_version.reload

        Success schema_version
      end

      wrapped_hook! def build_each_root
        Layout.each do |layout|
          yield build_root_for layout.kind
        end

        super
      end

      private

      # @param [Layouts::Types::Kind] layout_kind
      # @return [Dry::Monads::Success(LayoutDefinition)]
      do_for! def build_root_for(layout_kind)
        layout_definition = schema_version.root_layout_for(layout_kind)

        layout_definition.save!

        yield build_templates_for(layout_definition:)

        Success layout_definition
      end

      do_for! def build_templates_for(layout_definition:)
        template_names = layout_definition.template_definition_names

        template_names.each_with_index do |name, index|
          layout_definition.__send__(name).delete_all

          position = index + 1

          template_def = layout_definition.__send__(name).build(position:)

          template_def.save!
        end

        Success()
      end
    end
  end
end
