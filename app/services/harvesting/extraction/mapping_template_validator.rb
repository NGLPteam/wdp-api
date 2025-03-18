# frozen_string_literal: true

module Harvesting
  module Extraction
    # @see Harvesting::Extraction::ValidateMappingTemplate
    class MappingTemplateValidator < Support::HookBased::Actor
      include Dry::Effects::Handler.Interrupt(:halt, as: :catch_halt)
      include Dry::Effects.Interrupt(:halt)

      include Dry::Initializer[undefined: false].define -> do
        param :mapping_template, Types::String.optional
      end

      standard_execution!

      # @return [<Symbol>]
      attr_reader :errors

      # @return [Harvesting::Extraction::Mapping]
      attr_reader :mapping

      # @return [Dry::Monads::Result]
      def call
        run_callbacks :execute do
          yield prepare!

          yield parse!
        end

        if errors.any?
          Failure[:invalid_mapping_template, errors]
        else
          Success mapping
        end
      end

      wrapped_hook! def prepare
        @errors = []

        @mapping = nil

        super
      end

      wrapped_hook! def parse
        if mapping_template.blank?
          @errors << :"extraction_mapping_template.blank"

          return
        end

        @mapping = Harvesting::Extraction::Mapping.from_xml(mapping_template)
      rescue StandardError
        # Shale doesn't have great error boundaries, all sorts of errors can raise
        halt!(:"extraction_mapping_template.not_well_formed")
      else
        halt!(:"extraction_mapping_template.no_entities") unless mapping.has_entities?

        super
      end

      around_execute :with_halt!

      private

      # @return [void]
      def with_halt!
        catch_halt do
          yield
        end
      end

      # @param [Symbol] message
      # @return [void]
      def halt!(message)
        @errors << message

        halt
      end
    end
  end
end
