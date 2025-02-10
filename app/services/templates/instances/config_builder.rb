# frozen_string_literal: true

module Templates
  module Instances
    # @see Templates::Instances::BuildConfig
    class ConfigBuilder < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_instance, ::Templates::Types::TemplateInstance
      end

      standard_execution!

      delegate :template_definition, to: :template_instance
      delegate :config, to: :template_definition, prefix: :definition

      # @return [Templates::Instances::Config]
      attr_reader :config

      # @return [Dry::Monads::Success(Templates::Instances::Config)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield inherit!
        end

        Success config
      end

      wrapped_hook! def prepare
        @config = Templates::Instances::Config.new

        super
      end

      wrapped_hook! def inherit
        config.accept! definition_config

        super
      end
    end
  end
end
