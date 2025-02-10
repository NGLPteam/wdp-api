# frozen_string_literal: true

module Templates
  module Definitions
    # @see Templates::Definitions::BuildConfig
    class ConfigBuilder < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_definition, ::Templates::Types::TemplateDefinition
      end

      standard_execution!

      delegate :template_record, to: :template_definition

      delegate :has_background?, :has_variant?, to: :template_record

      # @return [Templates::Definitions::Config]
      attr_reader :config

      # @return [Dry::Monads::Success(Templates::Definitions::Config)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield extract_background!

          yield extract_variant!
        end

        Success config
      end

      wrapped_hook! def prepare
        @config = Templates::Definitions::Config.new

        super
      end

      wrapped_hook! def extract_background
        return super unless has_background?

        config.background = template_definition.background

        config.dark = template_definition.dark_background?

        super
      end

      wrapped_hook! def extract_variant
        return super unless has_variant?

        config.variant = template_definition.variant

        super
      end
    end
  end
end
