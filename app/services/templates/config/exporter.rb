# frozen_string_literal: true

module Templates
  module Config
    class Exporter < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template, Templates::Types::TemplateDefinition
      end

      delegate :template_record, to: :template

      delegate :config_klass, to: :template_record

      standard_execution!

      # @return [Templates::Config::Utility::AbstractTemplate]
      attr_reader :config

      # @return [{ String => Object }]
      attr_reader :config_options

      # @return [Dry::Monads::Success(Templates::Config::Utility::AbstractTemplate)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield extract!

          yield build!
        end

        Success config
      end

      wrapped_hook! def prepare
        @config = nil

        @config_options = {}

        super
      end

      wrapped_hook! def extract
        config_options["position"] = template.position

        config_options.merge! template.export_properties

        config_options["slots"] = template.export_slots

        super
      end

      wrapped_hook! def build
        @config = config_klass.from_hash(config_options)

        super
      end
    end
  end
end
