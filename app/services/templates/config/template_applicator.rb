# frozen_string_literal: true

module Templates
  module Config
    # @see Templates::Config::ApplyTemplate
    class TemplateApplicator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :template_config, ::Templates::Types.Instance(::Templates::Config::Utility::AbstractTemplate)
        param :layout_definition, ::Templates::Types::LayoutDefinition
      end

      delegate :position, :template_record, to: :template_config

      delegate :definition_klass, to: :template_record, prefix: :template

      standard_execution!

      # @see Templates::Config::Utility::AbstractTemplate#to_template_definition_attrs
      # @return [{ Symbol => Object }]
      attr_reader :attrs

      # @return [TemplateDefinition]
      attr_reader :template_definition

      # @return [Dry::Monads::Success(TemplateDefinition)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield assign!

          yield persist!
        end

        Success template_definition
      end

      wrapped_hook! def prepare
        @template_definition = template_definition_klass.where(layout_definition:, position:).first_or_initialize

        @attrs = template_config.to_template_definition_attrs

        super
      end

      wrapped_hook! def assign
        template_definition.assign_attributes(attrs)

        super
      end

      wrapped_hook! def persist
        template_definition.save!

        super
      end
    end
  end
end
