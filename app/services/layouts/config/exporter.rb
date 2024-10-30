# frozen_string_literal: true

module Layouts
  module Config
    class Exporter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :layout, Layouts::Types::LayoutDefinition
      end

      delegate :layout_record, to: :layout

      delegate :config_klass, to: :layout_record

      standard_execution!

      # @return [Templates::Config::Utility::AbstractLayout]
      attr_reader :config

      # @return [{ String => Object }]
      attr_reader :config_options

      # @return [Templates::Config::Utility::PolymorphicTemplateSet]
      attr_reader :templates

      # @return [Dry::Monads::Success(Templates::Config::Utility::AbstractLayout)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield export_templates!

          yield build!
        end

        Success config
      end

      wrapped_hook! def prepare
        @config = nil

        @config_options = {}

        @templates = ::Templates::Config::Utility::PolymorphicTemplateSet.new

        super
      end

      wrapped_hook! def export_templates
        layout.template_definitions.each do |template_definition|
          template = yield template_definition.export

          templates << template
        end

        super
      end

      wrapped_hook! def build
        @config = config_klass.from_hash(config_options)

        @config.templates = templates

        super
      end
    end
  end
end
